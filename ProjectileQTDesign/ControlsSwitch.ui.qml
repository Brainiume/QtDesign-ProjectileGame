import QtQuick.Templates as T
import QtQuick
import QtQml

T.Switch {
    enum Status_1 {
        Status_1_Default,
        Status_1_Disabled,
        Status_1_Hovered,
        Status_1_Pressed
    }
    enum Check_1 {
        Check_1_Off,
        Check_1_On
    }

    id: switchRoot

    property int check: ControlsSwitch.Check_1.Check_1_Off
    property int status: ControlsSwitch.Status_1.Status_1_Default

    height: 16
    width: 32

    background: Rectangle {
        id: controlsSwitch

        color: "#cdcdcd"
        radius: 8
    }
    contentItem: Item {
        id: switchRootCI
    }
    indicator: Item {
        id: switchRootindicator

        Rectangle {
            id: indicator

            x: 2
            y: 2

            height: 12
            width: 12

            clip: true
            color: "#fcfcfc"
            radius: 12
        }
    }

    states: [
        State {

            name: "Status=Default, Check=Off"
            when: switchRoot.status === ControlsSwitch.Status_1.Status_1_Default
                  && switchRoot.check === ControlsSwitch.Check_1.Check_1_Off
            PropertyChanges {
                target: game
                debugBoxEnabled: false
            }
        },
        State {
            name: "Status=Default, Check=On"
            when: switchRoot.status === ControlsSwitch.Status_1.Status_1_Default
                  && switchRoot.check === ControlsSwitch.Check_1.Check_1_On

            PropertyChanges {
                color: "#27bf73"
                target: controlsSwitch
            }
            PropertyChanges {
                x: 18
                target: indicator
            }

            PropertyChanges {
                target: game
                debugBoxEnabled: true
            }
        },
        State {
            name: "Status=Hovered, Check=Off"
            when: switchRoot.status === ControlsSwitch.Status_1.Status_1_Hovered
                  && switchRoot.check === ControlsSwitch.Check_1.Check_1_Off
        },
        State {
            name: "Status=Hovered, Check=On"
            when: switchRoot.status === ControlsSwitch.Status_1.Status_1_Hovered
                  && switchRoot.check === ControlsSwitch.Check_1.Check_1_On

            PropertyChanges {
                color: "#1f9b5d"
                target: controlsSwitch
            }
            PropertyChanges {
                x: 18

                target: indicator
            }
        },
        State {
            name: "Status=Pressed, Check=Off"
            when: switchRoot.status === ControlsSwitch.Status_1.Status_1_Pressed
                  && switchRoot.check === ControlsSwitch.Check_1.Check_1_Off

            PropertyChanges {
                width: 18

                target: indicator
            }
        },
        State {
            name: "Status=Pressed, Check=On"
            when: switchRoot.status === ControlsSwitch.Status_1.Status_1_Pressed
                  && switchRoot.check === ControlsSwitch.Check_1.Check_1_On

            PropertyChanges {
                color: "#12834b"
                target: controlsSwitch
            }
            PropertyChanges {
                x: 12

                target: indicator
            }
            PropertyChanges {
                width: 18

                target: indicator
            }
        },
        State {
            name: "Status=Disabled, Check=Off"
            when: switchRoot.status === ControlsSwitch.Status_1.Status_1_Disabled
                  && switchRoot.check === ControlsSwitch.Check_1.Check_1_Off

            PropertyChanges {
                color: "#aeaeae"
                target: indicator
            }
        },
        State {
            name: "Status=Disabled, Check=On"
            when: switchRoot.status === ControlsSwitch.Status_1.Status_1_Disabled
                  && switchRoot.check === ControlsSwitch.Check_1.Check_1_On

            PropertyChanges {
                color: "#e3e3e3"
                target: controlsSwitch
            }
            PropertyChanges {
                x: 18

                target: indicator
            }
            PropertyChanges {
                color: "#aeaeae"
                target: indicator
            }
        }
    ]

    Binding {
        property: "status"
        target: switchRoot
        value: !switchRoot.enabled ? ControlsSwitch.Status_1.Status_1_Disabled : switchRoot.down ? ControlsSwitch.Status_1.Status_1_Pressed : switchRoot.hovered ? ControlsSwitch.Status_1.Status_1_Hovered : ControlsSwitch.Status_1.Status_1_Default
    }
    Binding {
        property: "check"
        target: switchRoot
        value: switchRoot.checked ? ControlsSwitch.Check_1.Check_1_On : ControlsSwitch.Check_1.Check_1_Off
    }
}
