#include "mediaplayer.h"
#include <QMediaMetaData>

namespace
{
    const QString kRelativeFilePath = QStringLiteral("../../MediaPlayer/Audio/");

}

MediaPlayer::MediaPlayer(QObject *parent) : QObject(parent)
{
    m_player = new QMediaPlayer();
    setAudioVolume(50);

    connect(m_player, SIGNAL(stateChanged(QMediaPlayer::State)), this, SLOT(checkLooping(QMediaPlayer::State)));
    connect(m_player, SIGNAL(positionChanged(qint64)), this, SLOT(emitPositionChanged(qint64)));
    connect(m_player, SIGNAL(durationChanged(qint64)), this, SLOT(emitDurationChanged(qint64)));
    connect(m_player, SIGNAL(metaDataChanged()), this, SLOT(emitMetaDataChanged()));

}

MediaPlayer::~MediaPlayer()
{
    delete m_player;
}

void MediaPlayer::emitMetaDataChanged()
{
    emit metaDataObtained(getTitleName(), getAuthorName(), getThumbNailImage());
}

QString MediaPlayer::getTitleName()
{
    QString  title = "";
    title = m_player->metaData("Title").toString();
    if (title != "")
    {
        title = title.left(25)+"...";
    }
    return title;
}

QString MediaPlayer::getAuthorName()
{
    QString  author = "";
    author = m_player->metaData("Author").toString();
    if (author != "")
    {
        author = "-"+author.left(15)+"..";
    }
    return author;
}

QImage MediaPlayer::getThumbNailImage()
{
    QImage ret = m_player->metaData("ThumbnailImage").value<QImage>();
    return ret;
}

void MediaPlayer::emitDurationChanged(qint64 position)
{
    emit durationChanged(position);
}

void MediaPlayer::emitPositionChanged(qint64 position)
{
    emit positionChanged(position);
}

void MediaPlayer::setAudioPosition(int timeInMs)
{
    m_player->setPosition(timeInMs);
}

int MediaPlayer::getAudioPosition()
{
    return m_player->position();
}

void MediaPlayer::checkLooping(QMediaPlayer::State state)
{
    if (state == QMediaPlayer::StoppedState && m_loopCount > 0)
    {
        m_loopCount--;
        emit loopCountChanged(m_loopCount);
        playAudio();
    }
    else if(state == QMediaPlayer::StoppedState && m_loopCount == 0)
    {
        emit playingCompleted();
    }

}

int MediaPlayer::getAudioDuration()
{
    return m_player->duration();
}

void MediaPlayer::setFileName(const QString& fileName)
{
    m_fileName = fileName;
    m_player->setMedia(QUrl::fromLocalFile(QFileInfo((kRelativeFilePath + fileName)).absoluteFilePath()));
    qDebug()<<m_player->media().request().url();
}

QString MediaPlayer::getFileName()
{
    return m_fileName;
}

void MediaPlayer::playAudio()
{
    if ((m_player->state() == QMediaPlayer::PausedState) || (m_player->state() == QMediaPlayer::StoppedState))
    {
        m_player->play();
    }
}

void MediaPlayer::pauseAudio()
{
    if(m_player->state() == QMediaPlayer::PlayingState)
    {
        m_player->pause();
    }
}

void MediaPlayer::resumeAudio()
{
    if (m_player->state() == QMediaPlayer::PausedState)
    {
        m_player->play();
    }
}

QString MediaPlayer::getPlayingState()
{
    QString ret;
    if (m_player->state() == QMediaPlayer::PausedState)
    {
        ret = "Paused";
    }
    else if(m_player->state() == QMediaPlayer::PlayingState)
    {
        ret = "Playing";
    }
    else if(m_player->state() == QMediaPlayer::StoppedState)
    {
        ret = "Stopped";
    }
    return ret;
}

void MediaPlayer::stopAudio()
{
    if ((m_player->state() == QMediaPlayer::PlayingState) || (m_player->state() == QMediaPlayer::PausedState))
    {
        m_player->stop();
    }
}

void MediaPlayer::setMuted(bool mute)
{
    m_player->setMuted(mute);
}

bool MediaPlayer::getMuted()
{
    return m_player->isMuted();
}

void MediaPlayer::setAudioVolume(int volume)
{
    m_volume = volume;
    m_player->setVolume(m_volume);
}

int MediaPlayer::getAudioVolume()
{
    return m_volume;
}

void MediaPlayer::setLoopCount(int loopValue)
{
    m_loopCount = loopValue;
}

int MediaPlayer::getLoopCount()
{
    return m_loopCount;
}
