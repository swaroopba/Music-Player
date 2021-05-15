import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4


Rectangle
{

    property int mediaWidth: 20
    property int mediaHeight: 20
    property int loopCount: 0

    property double durationSliderValue: 0

    property bool isPlaying: false;
    property bool isShuffleOn: false;

    width: mediaWidth
    height: mediaHeight

    gradient: Gradient
    {
        GradientStop { position: 0.0; color: "#4f4d4d" }
        GradientStop { position: 1.0; color: "#3d3b3b" }
    }

    function playSongByIndex(index)
    {
        if (index < FileModel.getTotalSongsCount() && index >= 0)
        {
            MediaHandler.setFileName(FileModel.getSongName(index))
            MediaHandler.playAudio()
        }
    }

ColumnLayout
{
    id: mediaController



    width: parent.mediaWidth
    height: parent.mediaHeight

    Timer
    {
        id: volumeTimer
        interval: 6000
        onRunningChanged:
        {
            if (running == false)
            {
                if (volumeSlider.pressed === true)
                {
                    volumeTimer.restart()
                }
                else
                {
                    volumeRect.visible = false;
                }
            }
        }
    }

    Connections
    {
        target: MediaHandler

        function onPositionChanged(pos)
        {
            console.log("logging me->" + pos)
            durationSliderValue = pos
        }

        function onDurationChanged(duration)
        {
            console.log("duration"+duration)
            durationSlider.maximumValue = duration
        }

        function onPlayingCompleted()
        {
            isPlaying = false;
        }

        function onLoopCountChanged(number)
        {
            loopCount = number
        }

        function onSongStartedPlaying()
        {
            isPlaying = true;
        }
    }

    Rectangle
    {
        id: topRow

        width: mediaController.mediaWidth
        height: mediaController.mediaHeight/2
        color: "black"

        anchors
        {
            left: parent.left
            right: parent.right
        }


        Slider
        {
            id: durationSlider

            anchors
            {
                verticalCenter: topRow.verticalCenter
            }

            minimumValue: 0
            value: durationSliderValue
            width: parent.width
            height: parent.height

            onValueChanged:
            {
                if (pressed)
                {
                    MediaHandler.setAudioPosition(value)
                }
            }
        }
    }


    RowLayout
    {
        id: bottomRow

        width: mediaController.mediaWidth
        height: mediaController.mediaHeight/2
        spacing: (loopButton.itemWidth < 100) ? 4 : 20

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: (loopButton.itemWidth < 100) ? 15 : 60

        MediaButton
        {
            id: shuffleButton

            itemWidth: mediaWidth/11
            itemHeight: parent.height
            imgSrc: isShuffleOn ? "Images/shuffle_dark.png" : "Images/shuffle_light.png"

            scale: (loopButton.itemWidth < 100) ? loopButton.itemWidth/90 : 1

            onClicked:
            {
                isShuffleOn = !isShuffleOn
            }
        }

        MediaButton
        {
            id: previousButton

            itemWidth: mediaWidth/11
            itemHeight: parent.height
            imgSrc: "Images/previous.png"

            scale: (loopButton.itemWidth < 100) ? loopButton.itemWidth/90 : 1

            onClicked:
            {
                var prevIndex
                var currentIndex = MediaHandler.getCurrectPlayingSongIndex();
                if (isShuffleOn)
                {
                    var maxSongs = FileModel.getTotalSongsCount()
                    var random = Math.floor((Math.random() * (maxSongs-1)) + 1);
                    random = random % maxSongs;
                    prevIndex = random
                }
                else
                {
                    prevIndex = currentIndex - 1
                }
            }

        }

        MediaButton
        {
            id: playButton

            itemWidth: mediaWidth/11
            itemHeight: parent.height
            imgSrc: isPlaying ? "Images/pause.png" :"Images/play.png"

            scale: (loopButton.itemWidth < 100) ? loopButton.itemWidth/90 : 1

            onClicked:
            {
                if (MediaHandler.getFileName() !== "")
                {
                    var playingState = MediaHandler.getPlayingState()
                    var playingDuration
                    if (playingState === "Stopped")
                    {

                        playingDuration = MediaHandler.getDuration()
                        MediaHandler.playAudio()
                        isPlaying = true
                    }
                    else if(playingState === "Playing")
                    {
                        MediaHandler.pauseAudio()
                        isPlaying = false

                    }
                    else
                    {
                        MediaHandler.playAudio()
                        isPlaying = true
                    }
                }
            }
        }

        MediaButton
        {
            id: nextButton

            itemWidth: mediaWidth/11
            itemHeight: parent.height
            imgSrc: "Images/next.png"

            scale: (loopButton.itemWidth < 100) ? loopButton.itemWidth/90 : 1

            onClicked:
            {
                var currentIndex = MediaHandler.getCurrectPlayingSongIndex();
                var nextIndex;
                if (isShuffleOn)
                {
                    var maxSongs = FileModel.getTotalSongsCount()
                    var random = Math.floor((Math.random() * (maxSongs-1)) + 1);
                    random = random % maxSongs;
                    nextIndex = random
                }
                else
                {
                    nextIndex = currentIndex + 1
                }

                playSongByIndex(nextIndex)
            }
        }

        MediaButton
        {
            id: loopButton

            scale: (loopButton.itemWidth < 100) ? loopButton.itemWidth/90 : 1

            itemWidth: mediaWidth/11
            itemHeight: parent.height
            imgSrc: "Images/repeat_%1.png".arg(loopCount)

            onClicked:
            {
                loopCount = (loopCount + 1) % 3
                MediaHandler.setLoopCount(loopCount)
            }
        }

    }


    ColumnLayout
    {

        width: loopButton.width
        height: 2 * mediaController.height

        //scale: (mediaController.mediaWidth/11 < 100) ? (mediaController.mediaWidth/9)/90 : 1

        anchors
        {

            right: mediaController.right
            bottom: bottomRow.bottom
            rightMargin: (loopButton.itemWidth < 100) ? 15 : 60

        }

        Item
        {
            height: 2 * mediaController.height - bottomRow.height
            width: soundButton.width
            visible: !volumeRect.visible

            scale: (loopButton.itemWidth < 100) ? loopButton.itemWidth/90 : 1

            //scale: (loopButton.itemWidth < 100) ? loopButton.itemWidth/90 : 1
        }

        Rectangle
        {
            id: volumeRect

            anchors.bottom: soundButton.top
            anchors.bottomMargin: (loopButton.itemWidth < 100) ? -1 * loopButton.itemWidth/4 : 1

            scale: (loopButton.itemWidth < 100) ? loopButton.itemWidth/90 : 1

            radius: 1
            //border.color: "black"

            width: soundButton.itemWidth
            height:  mediaController.height + topRow.height + (bottomRow.height/2 - soundButton.height/2)
            //color: "grey"
            visible: false

            gradient: Gradient
            {
                GradientStop { position: 0.0; color: "#a8a7a7" }
                GradientStop { position: 1.0; color: "#949191" }
            }

            Slider
            {
                id: volumeSlider

                width: parent.width
                height: parent.height
                minimumValue: 0
                maximumValue: 100
                value: 50
                orientation: 0

                onValueChanged:
                {
                    MediaHandler.setAudioVolume(value)
                }
            }
        }

        MediaButton
        {
            id: soundButton

            itemWidth: mediaWidth/11
            itemHeight: parent.height
            imgSrc: "Images/sound_on.png"


            scale: (loopButton.itemWidth < 100) ? loopButton.itemWidth/90 : 1

            //anchors.bottom: mediaController.bottom
            anchors.top: loopButton.top
            anchors.verticalCenter: bottomRow.verticalCenter

            onClicked:
            {
                volumeRect.visible = true
                volumeTimer.start()
            }
        }

    }

}}

