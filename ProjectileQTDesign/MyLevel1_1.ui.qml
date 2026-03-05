import QtQuick
import QtQuick.Controls

Image {
    id: level1_1

    source: Qt.resolvedUrl("assets/level1_1.png")

    Item {
        id: levelCollisionLayer
        width: 200
        height: 200

        Rectangle {
            id: collision1
            x: 0
            y: 189
            width: 456
            height: 262
            visible: false
            color: "#7aff0000"
            property string hitboxType: "collisionBox"
        }

        Rectangle {
            id: collision2
            x: 452
            y: 154
            width: 154
            height: 297
            visible: false
            color: "#7aff0000"
            property string hitboxType: "collisionBox"
        }

        Rectangle {
            id: collision3
            x: 603
            y: 41
            width: 186
            height: 410
            visible: false
            color: "#7aff0000"
            property string hitboxType: "collisionBox"
        }

        Rectangle {
            id: collision4
            x: 789
            y: 189
            width: 75
            height: 262
            visible: false
            color: "#7aff0000"
            property string hitboxType: "collisionBox"
        }

        Rectangle {
            id: collision5
            x: 864
            y: 342
            width: 110
            height: 109
            visible: false
            color: "#7aff0000"
            property string hitboxType: "collisionBox"
        }

        Rectangle {
            id: collision6
            x: 971
            y: 377
            width: 87
            height: 74
            visible: false
            color: "#7aff0000"
            property string hitboxType: "collisionBox"
        }

        Rectangle {
            id: collision7
            x: 1056
            y: 342
            width: 40
            height: 109
            visible: false
            color: "#7aff0000"
            property string hitboxType: "collisionBox"
        }

        Rectangle {
            id: collision8
            x: 1094
            y: 192
            width: 186
            height: 259
            visible: false
            color: "#7aff0000"
            property string hitboxType: "collisionBox"
        }

        Rectangle {
            id: targetHitBox
            x: 1149
            y: 67
            width: 60
            height: 127
            visible: false
            color: "#02ff00"
            property string hitboxType: "targetBox"
        }

        Rectangle {
            id: killBox
            x: 864
            y: 218
            width: 232
            height: 176
            visible: false
            color: "#abff00ee"
            property string hitboxType: "killBox"
        }
    }

    ControlsButton {
        id: controlsButton
        x: 155
        y: 41
        visible: false
        buttonText: "Export Level"

        Connections {
            target: controlsButton
            function onClicked() {

                var levelData = {
                    "collisionBoxes": [],
                    "targets": [],
                    "killZones": []
                }

                for (var i = 0; i < levelCollisionLayer.children.length; i++) {

                    var item = levelCollisionLayer.children[i]

                    if (!item.hitboxType) {
                        continue
                    }

                    var pos = item.mapToItem(null, 0, 0)
                    var box = {
                        "x": pos.x,
                        "y": pos.y,
                        "width": item.width,
                        "height": item.height
                    }

                    switch (item.hitboxType) {
                    case "collisionBox":
                        levelData.collisionBoxes.push(box)
                        break
                    case "targetBox":
                        levelData.targets.push(box)
                        break
                    case "killBox":
                        levelData.killZones.push(box)
                        break
                    default:
                        break
                    }
                }

                game.saveLevelDev(JSON.stringify(levelData))
            }
        }
    }
}
