import QtQuick.Templates as T
import QtQuick
import QtQuick.Shapes
import QtQml

T.Button {
    enum Status_1 { Status_1_Default, Status_1_Disabled, Status_1_Hovered, Status_1_Pressed}

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
    
                source: Qt.resolvedUrl("assets/intersect_3.png")
            }
            Item {
                id: rotate_1
    
                x: 7
                y: 5
    
                height: 24
                width: 24
    
                Item {
                    id: frame
    
                    height: 24
                    width: 24
    
                    Item {
                        id: frame_1
    
                        height: 24
                        width: 24
    
                        Shape {
                            id: _vector
    
                            x: 1
                            y: 3
    
                            height: 20
                            width: 22
    
                            ShapePath {
                                id: _vector_ShapePath0
    
                                fillColor: "#00000000"
                                fillRule: ShapePath.WindingFill
                                strokeColor: "#ffffff"
                                strokeWidth: 2.50
    
                                PathSvg {
                                    id: _vector_ShapePath0_PathSvg0
    
                                    path: "M 7.0040688412630265 19.136583843504184 C 9.780020820710162 20.388617085695916 13.086392605061574 20.320628691947153 15.917780515306307 18.6587792200741 C 20.621910800486333 15.897813005435966 22.23361554064628 9.782917041250641 19.51770487659052 5.000724114667456 L 19.228433536240374 4.4913711444960445 M 2.482063943806654 14.99925288866224 C -0.23385830681631248 10.217083519643758 1.3778916761298667 4.102174935334485 6.081999339916778 1.3411969419140006 C 8.913364077027097 -0.32061733383559554 12.21973586137851 -0.3886063585905577 14.995699427392852 0.8633799086953664 M 0 15.097588894470412 L 3.1612149945227137 15.958745768332218 L 4.008259266244267 12.745028400326936 M 17.991740733755734 7.254266555415133 L 18.838842386572022 4.04060836176881 L 22 4.90170493948286"
                                }
                            }
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
                    
                        centerRadius: Math.max(line_1.width, line_1.height) * 2.175675670418363
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
        },
        State {
            name: "Status=Hovered"
            when: buttonRoot.status === ControlsButton.Status_1.Status_1_Hovered
    
            PropertyChanges {
                source: Qt.resolvedUrl("assets/intersect_2.png")
                target: intersect
            }
        },
        State {
            name: "Status=Pressed"
            when: buttonRoot.status === ControlsButton.Status_1.Status_1_Pressed
    
            PropertyChanges {
                source: Qt.resolvedUrl("assets/intersect_1.png")
                target: intersect
            }
        },
        State {
            name: "Status=Disabled"
            when: buttonRoot.status === ControlsButton.Status_1.Status_1_Disabled
    
            PropertyChanges {
                source: Qt.resolvedUrl("assets/intersect.png")
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
        }
    ]

    Binding {
        property: "status"
        target: buttonRoot
        value: !buttonRoot.enabled ? ControlsButton.Status_1.Status_1_Disabled
            : buttonRoot.down ? ControlsButton.Status_1.Status_1_Pressed
            : buttonRoot.hovered ? ControlsButton.Status_1.Status_1_Hovered
            : ControlsButton.Status_1.Status_1_Default
    }
}