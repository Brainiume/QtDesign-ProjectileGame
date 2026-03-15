import QtQuick.Templates as T
import QtQuick
import QtQuick.Shapes
import QtQml
import QtQuick.VectorImage 6.8

T.Button {
    enum Status_1 {
        Status_1_Default,
        Status_1_Disabled,
        Status_1_Hovered,
        Status_1_Pressed
    }

    id: buttonRoot

    property int status: ControlsButton.Status_1.Status_1_Default

    height: 37
    width: 38

    background: Rectangle {
        id: controlsButton

        color: "transparent"
        radius: 4
    }
    contentItem: Item {
        id: buttonRootCI

        Rectangle {
            id: launch

            height: 37
            width: 38

            border.color: "#78ded5d5"
            border.width: 1
            clip: true
            color: "#212741"
            radius: 9

            Rectangle {
                id: mask

                height: 37
                width: 175

                color: "transparent"
                radius: 9
            }
            Image {
                id: intersect

                source: Qt.resolvedUrl("assets/ReloadButton/intersect_3.png")
            }
            Item {
                id: rotate_1

                height: 24
                anchors.centerIn: parent
                width: 24

                Item {
                    id: frame

                    height: 24
                    anchors.centerIn: parent
                    width: 24

                    Item {
                        id: frame_1

                        height: 24
                        anchors.centerIn: parent
                        width: 24

                        VectorImage {
                            id: vectorImage

                            height: 20
                            source: "assets/ReloadButton/Reload.svg"
                            anchors.centerIn: parent
                            antialiasing: true
                            preferredRendererType: VectorImage.CurveRenderer
                            width: 22
                        }
                    }
                }
            }
            Shape {
                id: line_1

                x: 4.65
                y: 18.50

                height: 0
                width: 29.70

                rotation: 45
                visible: false

                ShapePath {
                    id: line_1_ShapePath0

                    fillColor: "transparent"
                    strokeColor: "transparent"
                    strokeWidth: 2.50

                    fillGradient: RadialGradient {
                        id: line_1_ShapePath0_RadialGradient

                        centerRadius: Math.max(
                                          line_1.width,
                                          line_1.height) * 2.175675670418363
                        centerX: line_1.width * 1.065789594136985
                        centerY: line_1.height * 1.2027026816734523
                        focalRadius: Math.max(line_1.width, line_1.height) * 0
                        focalX: line_1.width * 1.065789594136985
                        focalY: line_1.height * 1.2027026816734523

                        GradientStop {
                            id: line_1_ShapePath0_RadialGradient_GradientStop0

                            color: "#ffffffff"
                            position: 0
                        }
                        GradientStop {
                            id: line_1_ShapePath0_RadialGradient_GradientStop1

                            color: "#5bffffff"
                            position: 0.42
                        }
                        GradientStop {
                            id: line_1_ShapePath0_RadialGradient_GradientStop2

                            color: "#2effffff"
                            position: 0.63
                        }
                        GradientStop {
                            id: line_1_ShapePath0_RadialGradient_GradientStop3

                            color: "#00ffffff"
                            position: 1
                        }
                    }

                    PathSvg {
                        id: line_1_ShapePath0_PathSvg0

                        path: "M 0 0 L 29.698484420776367 0"
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "Status=Default"
            when: buttonRoot.status === ControlsButton.Status_1.Status_1_Default

            PropertyChanges {
                target: buttonRoot
                antialiasing: true
                smooth: true
            }
        },
        State {
            name: "Status=Hovered"
            when: buttonRoot.status === ControlsButton.Status_1.Status_1_Hovered

            PropertyChanges {
                source: Qt.resolvedUrl("assets/ReloadButton/intersect_2.png")
                target: intersect
            }

            PropertyChanges {
                target: buttonRoot
                antialiasing: true
            }
        },
        State {
            name: "Status=Pressed"
            when: buttonRoot.status === ControlsButton.Status_1.Status_1_Pressed

            PropertyChanges {
                source: Qt.resolvedUrl("assets/ReloadButton/intersect_1.png")
                target: intersect
            }

            PropertyChanges {
                target: buttonRoot
                antialiasing: true
            }
        },
        State {
            name: "Status=Disabled"
            when: buttonRoot.status === ControlsButton.Status_1.Status_1_Disabled

            PropertyChanges {
                source: Qt.resolvedUrl("assets/ReloadButton/intersect.png")
                target: intersect
            }
            PropertyChanges {
                strokeColor: "#c8c8c8"
                target: _vector_ShapePath0
            }
            PropertyChanges {
                target: line_1
                visible: true
            }
            PropertyChanges {
                strokeColor: "#ffffff"
                target: line_1_ShapePath0
            }
            PropertyChanges {
                fillColor: "white"
                target: line_1_ShapePath0
            }

            PropertyChanges {
                target: buttonRoot
                antialiasing: true
            }
        }
    ]

    Binding {
        property: "status"
        target: buttonRoot
        value: !buttonRoot.enabled ? ControlsButton.Status_1.Status_1_Disabled : buttonRoot.down ? ControlsButton.Status_1.Status_1_Pressed : buttonRoot.hovered ? ControlsButton.Status_1.Status_1_Hovered : ControlsButton.Status_1.Status_1_Default
    }
}
