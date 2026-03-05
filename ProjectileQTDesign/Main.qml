import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic


ApplicationWindow {
    id: approot
    width: 1280
    height: 832
    visible: true
    title: "Projectile Game"

    Screen_1 {
        anchors.fill: parent
    }

    Component.onCompleted: {
        game.setScreenHeight(approot.height)
    }
}