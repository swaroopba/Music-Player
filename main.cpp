#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "mediahandler.h"
#include <QQmlContext>


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

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
    engine.addImageProvider("imageprovider", m_mediaHandlerPtr->getImageProvider());

    engine.load(url);

    return app.exec();
}
