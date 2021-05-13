#ifndef IMAGEPROVIDER_H
#define IMAGEPROVIDER_H
#include <QQuickImageProvider>


class ImageProvider: public QObject, public QQuickImageProvider
{
    Q_OBJECT
public:
    ImageProvider();

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

signals:
    void updateThumbNailImage();
    void imageAvailable(QImage);

public slots:
    void onUpdateThumbNailImage(QImage);

private:
    QImage m_image;
};

#endif // IMAGEPROVIDER_H
