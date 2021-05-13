import QtQuick 2.0

Rectangle
{

    id: button

    property int itemWidth: 10
    property int itemHeight: 10
    property string imgSrc: ""
    property int imageWidth: 100
    property int imageHeight: 100
    property string itemText: ""
    property string clickedBgColor: "black"
    property string releasedBgColor: "red"

    onItemWidthChanged: console.log("changed button width->"+itemWidth)

    signal clicked;

    scale: (itemWidth < 100) ? itemWidth/90 : 1

    radius: button.imageWidth
    width:  button.itemWidth
    height: button.itemWidth
    color: (clickContainer.pressed === true) ? button.clickedBgColor : button.releasedBgColor

    Text
    {
        id: textContainer
        text: qsTr(text)
    }

    MouseArea
    {
        id: clickContainer
        anchors.fill: parent

        onClicked: button.clicked()
    }

    Image
    {
        id: imageContainer
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        width: button.width / 2
        height: button.width / 2

        source: imgSrc
    }
}
