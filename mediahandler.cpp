#include "mediahandler.h"

MediaHandler::MediaHandler(QObject *parent) : QObject(parent)
{
    m_mediaPlayerPtr = QSharedPointer<MediaPlayer>(new MediaPlayer);

    connect(m_mediaPlayerPtr.data(), SIGNAL(positionChanged(qint64)), this, SLOT(emitPositionChanged(qint64)));
    connect(m_mediaPlayerPtr.data(), SIGNAL(durationChanged(qint64)), this, SLOT(emitDurationChanged(qint64)));
    connect(m_mediaPlayerPtr.data(), SIGNAL(playingCompleted()), this, SLOT(emitPlayingCompleted()));
    connect(m_mediaPlayerPtr.data(), SIGNAL(loopCountChanged(qint16)), this, SLOT(emitLoopCountChanged(qint16)));

}

void MediaHandler::emitLoopCountChanged(qint16 num)
{
    emit loopCountChanged(num);
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
    qDebug()<<"Position Change2";
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
    m_mediaPlayerPtr->setFileName(fileName);
}

QString MediaHandler::getFileName()
{
    return m_mediaPlayerPtr->getFileName();
}

void MediaHandler::playAudio()
{
    m_mediaPlayerPtr->playAudio();
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
