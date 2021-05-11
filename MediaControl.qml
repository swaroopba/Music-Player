import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

ColumnLayout
{
    id: mediaController

    property int mediaWidth: 20
    property int mediaHeight: 20
    property int loopCount: 0

    property double durationSliderValue: 0;

    property bool isPlaying: false;

    width: mediaController.mediaWidth
    height: mediaController.mediaHeight


    Timer
    {
        id: volumeTimer
        interval: 6000
        onRunningChanged:
        {
            if (running == false)
            {
                console.log("timer destroted")
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
            isPlaying = false
        }

        function onLoopCountChanged(number)
        {
            loopCount = number
        }
    }


    Rectangle
    {
        id: topRow

        width: mediaController.mediaWidth
        height: mediaController.mediaHeight/2
        color: "green"

        anchors
        {
            left: parent.left
            top: parent.top
            right: parent.right
            verticalCenter: topRow.verticalCenter
        }

        Slider
        {
            id: durationSlider

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
        //anchors.fill: parent
        id: bottomRow

        width: parent.width
        height: parent.height/2
        spacing: 10

        anchors
        {
            horizontalCenter: parent.horizontalCenter
            //top: topRow.bottom
            bottom: parent.bottom
        }


        Item
        {
            width: 3 * mediaWidth/10
            height: parent.height
        }

        MediaButton
        {
            itemWidth: mediaWidth/10
            itemHeight: parent.height
            imgSrc: "Images/shuffle_light.png"
        }

        MediaButton
        {
            itemWidth: mediaWidth/10
            itemHeight: parent.height
            imgSrc: "Images/previous.png"
        }

        MediaButton
        {
            id: playButton

            itemWidth: mediaWidth/10
            itemHeight: parent.height
            imgSrc: isPlaying ? "Images/pause.png" :"Images/play.png"

            onClicked:
            {
                var playingState = MediaHandler.getPlayingState()
                var playingDuration
                if (playingState === "Stopped")
                {
                    MediaHandler.setFileName("Pokemon.mp3")
                    playingDuration = MediaHandler.getDuration()

                    console.log("Playing Duration->"+playingDuration)

                    //durationSlider.maximumValue = playingDuration
                    MediaHandler.playAudio()
                    isPlaying = true
                }
                else if(playingState === "Playing")
                {
                    MediaHandler.pauseAudio()
                    isPlaying = false

                }
                else {
                    MediaHandler.playAudio()
                    isPlaying = true
                }
            }
        }

        MediaButton
        {
            itemWidth: mediaWidth/10
            itemHeight: parent.height
            imgSrc: "Images/next.png"
        }

        MediaButton
        {
            id: loopButton

            itemWidth: mediaWidth/10
            itemHeight: parent.height
            imgSrc: "Images/repeat_%1.png".arg(loopCount)

            onClicked:
            {
                loopCount = (loopCount + 1) % 3
                MediaHandler.setLoopCount(loopCount)
            }
        }

        Item
        {
            width: bottomRow.width/2 - 3 * soundButton.imageWidth
            height: parent.height
        }

        MediaButton
        {
            id: soundButton

            anchors.right: parent.right

            itemWidth: mediaWidth/10
            itemHeight: parent.height
            imgSrc: "Images/sound_on.png"

            onClicked:
            {
                volumeRect.visible = true
                volumeTimer.start()
            }
        }

        Rectangle
        {
            id: volumeRect

            //anchors.verticalCenter: bottomRow.verticalCenter
            anchors.bottom: soundButton.top


            x: soundButton.x + mediaWidth / 40
            y: -1 * mediaController.height
            width: mediaWidth / 20
            height: topRow.height
            color: "black"
            visible: false

            Slider
            {
                id: volumeSlider

                width: parent.width
                height: parent.height
                minimumValue: 0
                maximumValue: 100
                value: 50
                orientation: verticalCenter

                onValueChanged:
                {
                    MediaHandler.setAudioVolume(value)
                }
            }
        }

    }
}

