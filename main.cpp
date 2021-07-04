#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "mediahandler.h"
#include <QQmlContext>


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    qDebug()<<"Command arg count->"<<argc;

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    QSharedPointer<MediaHandler> m_mediaHandlerPtr = QSharedPointer<MediaHandler>(new MediaHandler);
    engine.rootContext()->setContextProperty("MediaHandler", m_mediaHandlerPtr.data() );
    engine.rootContext()->setContextProperty("ImageProvider", m_mediaHandlerPtr->getImageProvider());
    engine.rootContext()->setContextProperty("FileModel", m_mediaHandlerPtr->getModel());
    engine.addImageProvider("imageprovider", m_mediaHandlerPtr->getImageProvider());
    //m_mediaHandlerPtr->populateModel("../../MediaPlayer/Audio");

    engine.load(url);

    return app.exec();
}
