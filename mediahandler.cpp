#include "mediahandler.h"
#include <QDir>

MediaHandler::MediaHandler(QObject *parent) : QObject(parent)
{
    m_mediaPlayerPtr = QSharedPointer<MediaPlayer>(new MediaPlayer);
    m_imageProviderPtr = QSharedPointer<ImageProvider>(new ImageProvider);
    m_fileModelPtr = QSharedPointer<FileModel>(new FileModel);

    connect(m_mediaPlayerPtr.data(), SIGNAL(positionChanged(qint64)), this, SLOT(emitPositionChanged(qint64)));
    connect(m_mediaPlayerPtr.data(), SIGNAL(durationChanged(qint64)), this, SLOT(emitDurationChanged(qint64)));
    connect(m_mediaPlayerPtr.data(), SIGNAL(playingCompleted()), this, SLOT(emitPlayingCompleted()));
    connect(m_mediaPlayerPtr.data(), SIGNAL(loopCountChanged(qint16)), this, SLOT(emitLoopCountChanged(qint16)));
    connect(m_mediaPlayerPtr.data(), SIGNAL(metaDataObtained(QString, QString, QImage)), this, SLOT(emitMetaDataObtained(QString, QString, QImage)));
    //connect(this, SIGNAL(updateThumbNailImage(QImage)), m_imageProviderPtr.data(), SLOT(m_imageProviderPtr->onUpdateThumbNailImage(QImage)));

}

void MediaHandler::emitMetaDataObtained(QString title, QString author, QImage image)
{
    emit metaDataObtained(title, author, image);
    emit m_imageProviderPtr->imageAvailable(image);
    //qDebug()<<"Is Thum null->"<<image.isNull();
}

ImageProvider* MediaHandler::getImageProvider()
{
    return m_imageProviderPtr.data();
}

void MediaHandler::emitLoopCountChanged(qint16 num)
{
    emit loopCountChanged(num);
}

QString MediaHandler::getTitleName()
{
    return m_mediaPlayerPtr->getTitleName();
}

QString MediaHandler::getAuthorName()
{
    return m_mediaPlayerPtr->getAuthorName();
}

void MediaHandler::emitPlayingCompleted()
{
    emit playingCompleted();
}

void MediaHandler::emitDurationChanged(qint64 dur)
{
    emit durationChanged(dur);
}

void MediaHandler::emitPositionChanged(qint64 pos)
{
    //qDebug()<<"Position Change2";
    emit positionChanged(pos);
}

void MediaHandler::setAudioPosition(int timeInMs)
{
    m_mediaPlayerPtr->setAudioPosition(timeInMs);
}

int MediaHandler::getAudioPosition()
{
    return m_mediaPlayerPtr->getAudioPosition();
}

void MediaHandler::setFileName(const QString& fileName)
{
    m_mediaPlayerPtr->setFileName(m_fileModelPtr->getDirectory() + "/" + fileName);
    m_currentSong = QPair<int, QString>(m_fileModelPtr->getSongIndex(fileName), fileName);
}

void MediaHandler::populateModel(const QString& dirPath)
{
    QDir directory(dirPath);
    QStringList typeFilter;
    typeFilter << "*.mp3";
    directory.setNameFilters(typeFilter);
    QStringList fileCollection = directory.entryList();

    m_fileModelPtr->setDirectory(directory.absolutePath());
    m_fileModelPtr->setModelData(fileCollection);
    setFileName(fileCollection.at(0));
}

FileModel* MediaHandler::getModel()
{
    return m_fileModelPtr.data();
}

int MediaHandler::getCurrectPlayingSongIndex()
{
    return m_currentSong.first;
}

QString MediaHandler::getFileName()
{
    return m_mediaPlayerPtr->getFileName();
}

void MediaHandler::playAudio()
{
    m_mediaPlayerPtr->playAudio();
    emit songStartedPlaying();
}

void MediaHandler::pauseAudio()
{
    m_mediaPlayerPtr->pauseAudio();
}

void MediaHandler::resumeAudio()
{
    m_mediaPlayerPtr->resumeAudio();
}

void MediaHandler::stopAudio()
{
    m_mediaPlayerPtr->stopAudio();
}

void MediaHandler::setAudioVolume(int volume)
{
    m_mediaPlayerPtr->setAudioVolume(volume);
}

int MediaHandler::getAudioVolume()
{
    return m_mediaPlayerPtr->getAudioVolume();
}

void MediaHandler::setLoopCount(int loopValue)
{
    m_mediaPlayerPtr->setLoopCount(loopValue);
}

QString MediaHandler::getPlayingState()
{
    return m_mediaPlayerPtr->getPlayingState();
}

int MediaHandler::getDuration()
{
    return m_mediaPlayerPtr->getAudioDuration();
}

int MediaHandler::getLoopCount()
{
    return m_mediaPlayerPtr->getLoopCount();
}
