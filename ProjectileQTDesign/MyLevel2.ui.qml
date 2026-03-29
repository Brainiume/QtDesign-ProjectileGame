import QtQuick
import QtQuick.Controls

Item {
    id: level_2

    width: 1280
    height: 646

    Image {
        id: level2
        x: 0
        y: 0

        width: 1280
        height: 646
        source: "assets/level2.png"
        antialiasing: false
        smooth: false

        Item {
            id: levelCollisionLayer
            width: 200
            height: 200

            Rectangle {
                id: collision1
                x: 0
                y: 384
                width: 456
                height: 264
                visible: false
                color: "#7aff0000"
                property string hitboxType: "collisionBox"
            }

            Rectangle {
                id: collision2
                x: 452
                y: 349
                width: 154
                height: 299
                visible: false
                color: "#7aff0000"
                property string hitboxType: "collisionBox"
            }

            Rectangle {
                id: collision3
                x: 603
                y: 234
                width: 186
                height: 414
                visible: false
                color: "#7aff0000"
                property string hitboxType: "collisionBox"
            }

            Rectangle {
                id: collision4
                x: 789
                y: 394
                width: 75
                height: 254
                visible: false
                color: "#7aff0000"
                property string hitboxType: "collisionBox"
            }

            Rectangle {
                id: collision5
                x: 864
                y: 546
                width: 110
                height: 113
                visible: false
                color: "#7aff0000"
                property string hitboxType: "collisionBox"
            }

            Rectangle {
                id: collision6
                x: 948
                y: 384
                width: 140
                height: 67
                visible: false
                color: "#7aff0000"
                property string hitboxType: "collisionBox"
            }

            Rectangle {
                id: collision7
                x: 980
                y: 457
                width: 300
                height: 191
                visible: false
                color: "#7aff0000"
                property string hitboxType: "collisionBox"
            }

            Rectangle {
                id: collision8
                x: 1247
                y: 384
                width: 33
                height: 67
                visible: false
                color: "#7aff0000"
                property string hitboxType: "collisionBox"
            }

            Rectangle {
                id: targetHitBox
                x: 971
                y: 259
                width: 49
                height: 119
                visible: false
                color: "#02ff00"
                property string hitboxType: "targetBox"
            }

            Rectangle {
                id: killBox
                x: 864
                y: 401
                width: 384
                height: 139
                visible: false
                color: "#abff00ee"
                property string hitboxType: "killBox"
            }

            Rectangle {
                id: collision9
                x: 378
                y: 116
                width: 147
                height: 33
                visible: false
                color: "#7aff0000"
                property string hitboxType: "collisionBox"
            }

            Rectangle {
                id: collision10
                x: 342
                y: 155
                width: 145
                height: 37
                visible: false
                color: "#7aff0000"
                property string hitboxType: "collisionBox"
            }

            Rectangle {
                id: collision11
                x: 342
                y: 191
                width: 106
                height: 40
                visible: false
                color: "#7aff0000"
                property string hitboxType: "collisionBox"
            }

            Rectangle {
                id: collision12
                x: 752
                y: 106
                width: 37
                height: 125
                visible: false
                color: "#7aff0000"
                property string hitboxType: "collisionBox"
            }

            Rectangle {
                id: collision13
                x: 752
                y: 0
                width: 75
                height: 113
                visible: false
                color: "#7aff0000"
                property string hitboxType: "collisionBox"
            }

            Rectangle {
                id: collision14
                x: 682
                y: 77
                width: 41
                height: 36
                visible: false
                color: "#7aff0000"
                property string hitboxType: "collisionBox"
            }

            Rectangle {
                id: collision15
                x: 716
                y: 37
                width: 49
                height: 76
                visible: false
                color: "#7aff0000"
                property string hitboxType: "collisionBox"
            }

            Rectangle {
                id: collision16
                x: 811
                y: 37
                width: 58
                height: 76
                visible: false
                color: "#7aff0000"
                property string hitboxType: "collisionBox"
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
}
