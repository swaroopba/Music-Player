#ifndef MEDIAPLAYER_H
#define MEDIAPLAYER_H

#include <QObject>
#include <QMediaPlayer>
#include <QFileInfo>
#include <QImage>

class MediaPlayer : public QObject
{
    Q_OBJECT
public:
    explicit MediaPlayer(QObject *parent = nullptr);

    ~MediaPlayer();

    void setFileName(const QString& fileName);

    QString getFileName();

    QString getPlayingState();

    void playAudio();

    void pauseAudio();

    void resumeAudio();

    void stopAudio();

    void setMuted(bool mute);

    bool getMuted();

    void setAudioVolume(int volume);

    int getAudioVolume();

    void setLoopCount(int loopValue);

    int getLoopCount();

    void setAudioPosition(int timeInMs);

    QString getTitleName();

    QString getAuthorName();

    QImage getThumbNailImage();

    int getAudioPosition();

    int getAudioDuration();

private slots:
    void checkLooping(QMediaPlayer::State state); //#E9E3E5-shuffle color

    void emitPositionChanged(qint64 position);

    void emitDurationChanged(qint64 duration);

    void emitMetaDataChanged();

signals:
    void positionChanged(qint64 position);
    void durationChanged(qint64 duration);
    void playingCompleted();
    void loopCountChanged(qint16 num);
    void metaDataObtained(QString title, QString author, QImage image);

private:
    QMediaPlayer *m_player;
    QString m_fileName;
    //QString m_titleName;
    //QString m_authorName;
    int m_volume;
    int m_loopCount;
};

#endif // MEDIAPLAYER_H
