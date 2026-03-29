import QtQuick
import QtQuick.Effects

Item {
    id: root

    property Item blurSourceItem
    property Item targetItem
    property string heading: ""
    property string body: ""
    property string placement: "autoVertical"
    property int maxWidth: 320
    property int blurPadding: 56
    property int gap: 14
    property bool shown: false

    width: maxWidth
    height: tooltipCard.implicitHeight
    // Clip the stronger blur pass back to the tooltip bounds so it cannot paint over the config bar.
    clip: true
    visible: shown || opacity > 0.01
    opacity: shown ? 1 : 0
    z: 100

    Behavior on opacity {
        NumberAnimation {
            duration: 140
        }
    }

    readonly property point targetTopPoint: targetItem && parent
                                            ? targetItem.mapToItem(parent, targetItem.width / 2, 0)
                                            : Qt.point(0, 0)
    readonly property point targetBottomPoint: targetItem && parent
                                               ? targetItem.mapToItem(parent, targetItem.width / 2, targetItem.height)
                                               : Qt.point(0, 0)
    readonly property point targetRightPoint: targetItem && parent
                                              ? targetItem.mapToItem(parent, targetItem.width, targetItem.height / 2)
                                              : Qt.point(0, 0)
    readonly property point targetLeftPoint: targetItem && parent
                                             ? targetItem.mapToItem(parent, 0, targetItem.height / 2)
                                             : Qt.point(0, 0)
    // Keep tooltip placement declarative so .ui.qml files can control it with property assignments only.
    x: parent
       ? (root.placement === "right"
          ? Math.max(16, Math.min(parent.width - width - 16,
                                  targetRightPoint.x + root.gap))
          : root.placement === "left"
            ? Math.max(16, Math.min(parent.width - width - 16,
                                    targetLeftPoint.x - width - root.gap))
            : Math.max(16, Math.min(parent.width - width - 16,
                                    targetTopPoint.x - width / 2)))
       : 0
    y: parent
       ? (root.placement === "right" || root.placement === "left"
          ? Math.max(16, Math.min(parent.height - height - 16,
                                  targetRightPoint.y - height / 2))
          : ((targetTopPoint.y - height - root.gap) < 16
             ? Math.min(parent.height - height - 16,
                        targetBottomPoint.y + root.gap)
             : targetTopPoint.y - height - root.gap))
       : 0

    // Rounded mask keeps the frosted blur inside the tooltip shape.
    Rectangle {
        id: tooltipMask
        anchors.fill: parent
        radius: 14
        color: "#ffffff"
        opacity: 0.01
    }

    ShaderEffectSource {
        id: tooltipBlurSource
        x: -root.blurPadding
        y: -root.blurPadding
        width: root.width + root.blurPadding * 2
        height: root.height + root.blurPadding * 2
        sourceItem: root.blurSourceItem
        live: root.visible
        hideSource: false
        // Capture extra area around the tooltip so the blur can spread properly.
        sourceRect: Qt.rect(root.x - root.blurPadding, root.y - root.blurPadding,
                            width, height)
    }

    MultiEffect {
        x: -root.blurPadding
        y: -root.blurPadding
        width: tooltipBlurSource.width
        height: tooltipBlurSource.height
        autoPaddingEnabled: false
        source: tooltipBlurSource
        blurEnabled: true
        blur: 1.0
        blurMax: 128
        blurMultiplier: 3.2
        brightness: -0.1
        maskEnabled: true
        maskSource: tooltipMask
    }

    Rectangle {
        id: tooltipCard
        anchors.fill: parent
        implicitHeight: tooltipTextBlock.implicitHeight + 28
        radius: 14
        // Use the original project tint for the tooltip card.
        color: "#d3212741"
        border.color: "#7dded5d5"
        border.width: 1
    }

    Item {
        id: tooltipTextBlock
        x: 14
        y: 14
        width: root.width - 28
        implicitHeight: tooltipHeading.implicitHeight + tooltipBody.implicitHeight + 10

        Text {
            id: tooltipHeading
            width: parent.width
            color: "#ffffff"
            text: root.heading
            font.family: "Interstate"
            font.pixelSize: 15
            font.weight: Font.Bold
            wrapMode: Text.WordWrap
        }

        Text {
            id: tooltipBody
            y: tooltipHeading.implicitHeight + 10
            width: parent.width
            color: "#f2f5ff"
            text: root.body
            font.family: "Interstate"
            font.pixelSize: 13
            wrapMode: Text.WordWrap
            lineHeight: 1.15
        }
    }
}
