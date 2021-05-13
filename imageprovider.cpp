#include "imageprovider.h"
#include <QQmlImageProviderBase>

namespace
{
    const QString idName = QStringLiteral("thumbnail");
}

ImageProvider::ImageProvider():
    QQuickImageProvider(QQmlImageProviderBase::Image, QQmlImageProviderBase::ForceAsynchronousImageLoading)
{
    connect(this, SIGNAL(imageAvailable(QImage)), this, SLOT(onUpdateThumbNailImage(QImage)));
}

QImage ImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
//    Q_UNUSED(id);
//    Q_UNUSED(size);
//    Q_UNUSED(requestedSize);
    if (m_image.isNull())
    {
        return QImage();
    }
    else
    {
        return m_image;
    }
}

void ImageProvider::onUpdateThumbNailImage(QImage image)
{
    m_image = image;
    qDebug()<<"Reached in ImageProviderClass";
    emit updateThumbNailImage();
}
