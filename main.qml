import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3

Window {
    id: mainWindow

    width: 800
    height: 600
    visible: true
    title: qsTr("Media Player")
    color: "grey"

    DisplayScreen
    {
        id: displayScreen

        anchors
        {
            top: mainWindow.top
            bottom: mediaControl.top
        }

//        title: mediaControl.titleName
//        author: mediaControl.authorName

        height: mainWindow.height * 3/4
        width: mainWindow.width
    }


    MediaControl
    {
        id: mediaControl

        anchors
        {
            top: displayScreen.bottom
            bottom: mainWindow.bottom
            bottomMargin: 20
        }

        mediaHeight: mainWindow.height/4
        mediaWidth: mainWindow.width
    }

}
