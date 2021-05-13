#ifndef MEDIAHANDLER_H
#define MEDIAHANDLER_H

#include <QObject>
#include "mediaplayer.h"
#include "imageprovider.h"
#include <QSharedPointer>
#include <QImage>

class MediaHandler : public QObject
{
    Q_OBJECT

public:

    explicit MediaHandler(QObject *parent = nullptr);

    Q_INVOKABLE void setLoopCount(int loopValue);

    Q_INVOKABLE QString getTitleName();

    Q_INVOKABLE QString getAuthorName();

    Q_INVOKABLE int getLoopCount();

    Q_INVOKABLE void setAudioPosition(int timeInMs);

    Q_INVOKABLE int getAudioPosition();

    Q_INVOKABLE void setAudioVolume(int volume);

    Q_INVOKABLE int getAudioVolume();

    Q_INVOKABLE void playAudio();

    Q_INVOKABLE void pauseAudio();

    Q_INVOKABLE void resumeAudio();

    Q_INVOKABLE void stopAudio();

    Q_INVOKABLE void setFileName(const QString& fileName);

    Q_INVOKABLE QString getFileName();

    Q_INVOKABLE QString getPlayingState();

    Q_INVOKABLE int getDuration();

    ImageProvider* getImageProvider();

signals:

    void positionChanged(qint64 pos);
    void durationChanged(qint64 duration);
    void playingCompleted();
    void loopCountChanged(qint16 num);
    void metaDataObtained(QString title, QString author, QImage img);
    void updateThumbNailImage(QImage);

public slots:
    void emitPositionChanged(qint64 pos);
    void emitDurationChanged(qint64 duration);
    void emitPlayingCompleted();
    void emitLoopCountChanged(qint16 val);
    void emitMetaDataObtained(QString title, QString author, QImage img);

private:

    QSharedPointer<MediaPlayer> m_mediaPlayerPtr;
    QSharedPointer<ImageProvider> m_imageProviderPtr;
};

#endif // MEDIAHANDLER_H
