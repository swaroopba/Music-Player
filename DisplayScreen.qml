import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle
{
    id: displayScreen

    property string title: ""
    property string author: ""
    property string imgsrc: ""
    property int imageHeight: displayScreen.height/2
    property int imageWidth: displayScreen.width/2
    property bool isListVisible: false
    property int previousIndex: 0;

    gradient: Gradient
    {
        GradientStop { position: 0.0; color: "#3d3b3b" }
        GradientStop { position: 0.5; color: "#666565" }
        GradientStop { position: 1.0; color: "#4f4d4d" }
    }

    //color:"blue"

    Connections
    {
        target: MediaHandler

        function onMetaDataObtained(titleName, authorName, songIndex)
        {
            displayScreen.title = titleName;
            displayScreen.author = authorName;

            //make previous background disappper before setting new one
            var sample1 = songsList.itemAtIndex(previousIndex);
            sample1.border.width = 0
            sample1.border.color = "transparent"

            var sample = songsList.itemAtIndex(songIndex);
            sample.border.width = 2
            sample.border.color = "white"
            previousIndex = songIndex
        }
    }

    Connections
    {
        target: ImageProvider

        function onUpdateThumbNailImage()
        {
            displayImage.reload()
        }
    }


    function convertToDisplayableName(songName)
    {
        return String(songName).slice(0, 12);
    }

    function changeBorder(index)
    {
        var sample = songsList.itemAtIndex(index);
        sample.border.width = 0
        sample.border.color = "transparent"
    }

    Rectangle
    {
        id: nextButton

        height: (displayScreen.height < 500) ? displayScreen.height/10 : displayScreen.height/15
        width: (displayScreen.width < 1000) ? 18 : 24

        color: "red"

        anchors
        {
            left: songsList.right
            top: songsList.top
            topMargin: songsList.height/10
            leftMargin: 0//(displayScreen.width < 1000) ? 0 : -1 * displayScreen.width/12
        }


        Text
        {
            text: qsTr("NEXT")
            rotation: 270

            anchors.left: nextButton.left
            anchors.leftMargin: -8
            anchors.top: nextButton.top
            anchors.topMargin: 14

            color: "white"
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                isListVisible = !isListVisible
            }
        }
    }

    ListView
    {
        id: songsList

        height: parent.height * 2/3
        width: (displayScreen.width < 1000) ? displayScreen.width/4 : displayScreen.width/6

        anchors
        {
            left: displayScreen.left
            top: authorName.bottom
            leftMargin: isListVisible ? 0 : -1 * songsList.width
        }

        model: FileModel

        ScrollBar.vertical: ScrollBar
        {
            active: true
            anchors.left: songsList.right
            anchors.leftMargin: 0

            visible: isListVisible
        }

        delegate:
            Rectangle
         {
             id: rect

             gradient: Gradient
             {
                 GradientStop { position: 0.0; color: "#2500C9" }
                 GradientStop { position: 1.0; color: "#1c0191" }
             }

            opacity: 0.6

            width: (displayScreen.width < 1000) ? displayScreen.width/4 : displayScreen.width/6
            height: (displayScreen.height < 500) ? displayScreen.height/7 : displayScreen.height/10

            Text
            {
                id: txt
                text: convertToDisplayableName(songName)
                font.family: "Helvetica"; font.pointSize: 12;
                color: "white"

                anchors
                {
                    top: rect.top
                    left: rect.left
                    topMargin: 5
                    leftMargin: 5

                }
            }

            MouseArea
            {
                id: mouse
                anchors.fill: parent

                onClicked:
                {

                    MediaHandler.setFileName(songName)
                    MediaHandler.playAudio()
                }
            }
        }

    }


    Text
    {
        id: titleName

        anchors.horizontalCenter: displayScreen.horizontalCenter
        anchors.top: displayScreen.top
        anchors.topMargin: 10

        font.family: "Helvetica"; font.pointSize: 20;
        color: "white"
        text: title
    }

    Text
    {
        id: authorName

        //width: displayScreen.width/2
        //height: 20

        anchors
        {
            top: titleName.bottom
            left: titleName.right
            leftMargin: -6
        }
        color: "white"
        font.family: "Helvetica"; font.pointSize: 15;

        text: author
    }

    Image
    {
        id: displayImage

        anchors
        {
            horizontalCenter: displayScreen.horizontalCenter
            verticalCenter: displayScreen.verticalCenter
        }

        height: 250
        width: 220
        source: "image://imageprovider/thumbnail"

        cache: false
        function reload()
        {
            console.log("reload called")
            var oldSource = source;
            source = "";
            source = oldSource;
        }
    }

    onVisibleChanged:
    {
        console.log("In DisplayScreen visible changed")
    }

    Component.onCompleted:
    {
        console.log("In DisplayScreen completed")
        //MediaHandler.setFileName("Pokemon.mp3")
    }
}
