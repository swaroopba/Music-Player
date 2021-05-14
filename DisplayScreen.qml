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

        function onMetaDataObtained(titleName, authorName, image)
        {
            displayScreen.title = titleName;
            displayScreen.author = authorName;
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

    ListView
    {
        id: songsList

        height: parent.height
        width: parent.width/4


        anchors
        {
            left: displayScreen.left
            top: displayScreen.top
        }

//        ScrollBar {
//                id: vbar
//                hoverEnabled: true
//                active: hovered || pressed
//                orientation: Qt.Vertical
//                size: frame.height / content.height
//                anchors.top: parent.top
//                anchors.right: parent.right
//                anchors.bottom: parent.bottom
//            }

        model: FileModel

        delegate:
            Rectangle
         {
             id: rect

             gradient: Gradient
             {
                 GradientStop { position: 0.0; color: "#2500C9" }
                 GradientStop { position: 1.0; color: "#1c0191" }
             }

            width: displayScreen.width/4
            height: displayScreen.height/8
            border.color: "white"
            border.width: 2

            Text
            {
                id: txt
                text: convertToDisplayableName(songName)
                font.family: "Helvetica"; font.pointSize: 12;
                color: "white"

                anchors
                {
                    verticalCenter: rect.verticalCenter
                    horizontalCenter:rect.horizontalCenter
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
