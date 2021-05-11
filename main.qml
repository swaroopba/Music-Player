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


    MediaControl
    {
        mediaHeight: mainWindow.height/4
        mediaWidth: mainWindow.width
    }

}
