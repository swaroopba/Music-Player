import QtQuick 2.0

Rectangle
{
    id: displayScreen

    property string title: ""
    property string author: ""
    property string imgsrc: ""
    property int imageHeight: displayScreen.height/2
    property int imageWidth: displayScreen.width/2

    onTitleChanged: console.log("title->"+title)

    color:"blue"


    Connections
    {
        target: MediaHandler

        function onMetaDataObtained(titleName, authorName, image)
        {
            console.log("reached in displayScreen"+titleName)
            displayScreen.title = titleName;
            displayScreen.author = authorName;
            //displayImage.source = image;
        }
    }

    Connections
    {
        target: ImageProvider

        function onUpdateThumbNailImage()
        {
            console.log("image provider logged")
            displayImage.reload()
        }
    }

    Text
    {
        id: titleName

        //width: displayScreen.width/2
        //height: 20

        anchors.horizontalCenter: displayScreen.horizontalCenter
        anchors.top: displayScreen.top
        anchors.topMargin: 10

        font.family: "Helvetica"; font.pointSize: 20;

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
        }

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

        height: imageHeight
        width: imageWidth
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

}
