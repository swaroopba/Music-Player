import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

ColumnLayout
{
    id: mediaController

    property int mediaWidth: 20
    property int mediaHeight: 20
    property int loopCount: 0

    property double durationSliderValue: 0

//    property string titleName: ""
//    property string authorName: ""

    property bool isPlaying: false;

    width: mediaController.mediaWidth
    height: mediaController.mediaHeight

    onMediaHeightChanged: console.log("Changed ht->"+mediaHeight)
    onMediaWidthChanged: console.log("Changed wt->"+mediaWidth)
    //onTitleNameChanged: console.log("Changed title"+ titleName)


    Timer
    {
        id: volumeTimer
        interval: 6000
        onRunningChanged:
        {
            if (running == false)
            {
                //console.log("timer destroted")
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
            right: parent.right
        }


        Slider
        {
            id: durationSlider

            anchors
            {
                //left: parent.left
                //right: parent.right
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
        spacing: mediaController.mediaWidth/1000

        anchors.horizontalCenter: parent.horizontalCenter

        MediaButton
        {
            itemWidth: mediaWidth/11
            itemHeight: parent.height
            imgSrc: "Images/shuffle_light.png"
        }

        MediaButton
        {
            itemWidth: mediaWidth/11
            itemHeight: parent.height
            imgSrc: "Images/previous.png"
        }

        MediaButton
        {
            id: playButton

            itemWidth: mediaWidth/11
            itemHeight: parent.height
            imgSrc: isPlaying ? "Images/pause.png" :"Images/play.png"

            onClicked:
            {
                var playingState = MediaHandler.getPlayingState()
                var playingDuration
                if (playingState === "Stopped")
                {
                    MediaHandler.setFileName("Pokemon.mp3")
                    //authorName = MediaHandler.getAuthorName()
                    //titleName = MediaHandler.getTitleName()

                    playingDuration = MediaHandler.getDuration()

                    //console.log("Playing Duration->"+playingDuration)

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
            itemWidth: mediaWidth/11
            itemHeight: parent.height
            imgSrc: "Images/next.png"
        }

        MediaButton
        {
            id: loopButton

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

            width: mediaWidth/11
            height: mediaController.height
            anchors
            {

                right: mediaController.right
                top: topRow.top
                rightMargin: 10
            }

            Item
            {
                height: mediaController.height - bottomRow.height
                width: soundButton.width
                visible: !volumeRect.visible
            }

            Rectangle
            {
                id: volumeRect

                anchors.bottom: soundButton.top

                width: soundButton.itemWidth
                height: topRow.height + (bottomRow.height/2 - soundButton.height/2)
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

            anchors.bottom: mediaController.bottom
            anchors.verticalCenter: bottomRow.verticalCenter

            onClicked:
            {
                volumeRect.visible = true
                volumeTimer.start()
            }
        }


        }

}

