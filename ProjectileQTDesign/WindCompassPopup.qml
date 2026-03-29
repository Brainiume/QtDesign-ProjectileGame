import QtQuick
import QtQuick.Effects
import QtQuick.VectorImage 6.8

Item {
    id: root

    property Item blurSourceItem
    property Item targetItem
    property real windAngle: 0
    property real arrowRotation: 90 - windAngle
    property real windSpeed: 0
    property string cardinalDirection: "East"
    property string cardinalShort: "E"
    property bool shown: false
    readonly property bool hovered: popupHover.containsMouse
    readonly property string teachingText: teachingTextFromDirection(root.cardinalDirection, root.windSpeed)

    width: 248
    height: 286
    visible: shown || opacity > 0.01
    opacity: shown ? 1 : 0
    z: 120

    Behavior on opacity {
        NumberAnimation {
            duration: 140
        }
    }

    readonly property point targetPoint: targetItem && parent
                                         ? targetItem.mapToItem(parent, targetItem.width / 2, targetItem.height)
                                         : Qt.point(0, 0)
    // Open directly below the trigger card with a slight overlap so the mouse
    // can move from the card into the popup without flicker.
    x: parent
       ? Math.max(16, Math.min(parent.width - width - 16, targetPoint.x - width / 2))
       : 0
    y: parent
       ? Math.max(16, Math.min(parent.height - height - 16, targetPoint.y + 10))
       : 0

    function teachingTextFromDirection(direction, speed) {
        if (speed <= 0.05) {
            return "The wind is calm right now."
        }

        if (direction === "North" || direction === "South" || direction === "East"
                || direction === "West") {
            return "The wind is pushing " + direction + "."
        }

        if (direction === "North-East" || direction === "South-East"
                || direction === "South-West" || direction === "North-West") {
            var diagonalParts = direction.split("-")
            return "The wind is pushing " + diagonalParts[0] + " and " + diagonalParts[1] + "."
        }

        if (direction === "North-North-East") {
            return "The wind is pushing mostly North and a little East."
        }

        if (direction === "East-North-East") {
            return "The wind is pushing mostly East and a little North."
        }

        if (direction === "East-South-East") {
            return "The wind is pushing mostly East and a little South."
        }

        if (direction === "South-South-East") {
            return "The wind is pushing mostly South and a little East."
        }

        if (direction === "South-South-West") {
            return "The wind is pushing mostly South and a little West."
        }

        if (direction === "West-South-West") {
            return "The wind is pushing mostly West and a little South."
        }

        if (direction === "West-North-West") {
            return "The wind is pushing mostly West and a little North."
        }

        if (direction === "North-North-West") {
            return "The wind is pushing mostly North and a little West."
        }

        return "The wind is pushing " + direction + "."
    }

    Rectangle {
        id: popupMask
        anchors.fill: parent
        radius: 16
        color: "#ffffff"
        opacity: 0.01
    }

    ShaderEffectSource {
        id: popupBlurSource
        anchors.fill: parent
        sourceItem: root.blurSourceItem
        live: root.visible
        hideSource: false
        sourceRect: Qt.rect(root.x, root.y, root.width, root.height)
    }

    MultiEffect {
        anchors.fill: parent
        autoPaddingEnabled: false
        source: popupBlurSource
        blurEnabled: true
        blur: 1.0
        blurMax: 96
        blurMultiplier: 2.0
        brightness: -0.1
        maskEnabled: true
        maskSource: popupMask
    }

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: "#d3212741"
        border.color: "#7dded5d5"
        border.width: 1
        clip: true
    }

    MouseArea {
        id: popupHover
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        hoverEnabled: true
    }

    Text {
        x: 16
        y: 14
        width: parent.width - 32
        color: "#ffffff"
        text: "Wind Compass"
        font.family: "Interstate"
        font.pixelSize: 16
        font.weight: Font.Bold
    }

    Text {
        x: 16
        y: 38
        width: parent.width - 32
        color: "#edf4ff"
        text: "This compass shows which direction the wind is blowing."
        font.family: "Interstate"
        font.pixelSize: 12
        wrapMode: Text.WordWrap
    }

    Item {
        id: compass
        x: 70
        y: 74
        width: 108
        height: 108

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "#13274361"
            border.color: "#69ffffff"
            border.width: 1
        }

        Rectangle {
            x: width / 2 - 1
            y: 14
            width: 2
            height: height - 28
            color: "#44ffffff"
        }

        Rectangle {
            x: 14
            y: height / 2 - 1
            width: width - 28
            height: 2
            color: "#44ffffff"
        }

        Text {
            x: width / 2 - width / 2
            y: 6
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            color: "#ffffff"
            text: "N"
            font.family: "Interstate"
            font.pixelSize: 14
            font.weight: Font.Bold
        }

        Text {
            x: parent.width - 20
            y: parent.height / 2 - 10
            width: 16
            horizontalAlignment: Text.AlignHCenter
            color: "#ffffff"
            text: "E"
            font.family: "Interstate"
            font.pixelSize: 14
            font.weight: Font.Bold
        }

        Text {
            x: width / 2 - width / 2
            y: parent.height - 24
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            color: "#ffffff"
            text: "S"
            font.family: "Interstate"
            font.pixelSize: 14
            font.weight: Font.Bold
        }

        Text {
            x: 4
            y: parent.height / 2 - 10
            width: 16
            horizontalAlignment: Text.AlignHCenter
            color: "#ffffff"
            text: "W"
            font.family: "Interstate"
            font.pixelSize: 14
            font.weight: Font.Bold
        }

        VectorImage {
            id: compassArrow
            x: 35
            y: 20
            width: 38
            height: 68
            source: "assets/Arrow.svg"
            rotation: root.arrowRotation
            preferredRendererType: VectorImage.CurveRenderer
            antialiasing: true
            smooth: true
            fillMode: Image.PreserveAspectFit
            transformOrigin: Item.Center
        }

        Rectangle {
            anchors.centerIn: parent
            width: 14
            height: 14
            radius: 7
            color: "#ffffff"
            border.color: "#9db7ff"
            border.width: 1
        }
    }

    Column {
        x: 16
        y: 191
        width: parent.width - 32
        spacing: 6

        Text {
            width: parent.width
            color: "#92ff92"
            text: "Wind: " + root.cardinalDirection
            font.family: "Interstate"
            font.pixelSize: 14
            font.weight: Font.Bold
            wrapMode: Text.WordWrap
        }

        Text {
            width: parent.width
            color: "#ffffff"
            text: "Speed: " + root.windSpeed.toFixed(1) + " m/s"
            font.family: "Interstate"
            font.pixelSize: 13
            wrapMode: Text.WordWrap
        }

        Text {
            width: parent.width
            color: "#edf4ff"
            text: root.teachingText + " North is up, East is right."
            font.family: "Interstate"
            font.pixelSize: 12
            wrapMode: Text.WordWrap
        }
    }
}
