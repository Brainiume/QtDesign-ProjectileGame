import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.VectorImage 6.8

Rectangle {
    id: screen

    height: 832
    width: 1280

    clip: true
    color: "#ffffff"

    property var debugBoxes: []
    property real displayedVelocity: 0
    property real latestVelocity: 0
    property bool moreInfoOpen: false

    ListModel {
        id: impactEffectModel
    }

    Behavior on displayedVelocity {
        NumberAnimation {
            duration: 200
        }
    }

    Connections {
        target: game

        function onProjectilePositionChanged(NewX, NewY, NewRotation, Velocity) {
            rocket.x = NewX
            rocket.y = NewY
            latestVelocity = Velocity
        }

        function onDebugBoxesChanged(boxes) {
            console.log("Boxes received:", boxes.length)
            debugBoxes = boxes
        }

        function onImpactEffectTriggered(effectType, centerX, centerY) {
            // Keep dust subtle, but make the water splash fuller and easier to notice.
            var burstCount = effectType === "splash" ? 14 : 6
            impactEffectModel.clear()
            for (var i = 0; i < burstCount; i++) {
                impactEffectModel.append({
                                             "effectType": effectType,
                                             "effectX": centerX + (Math.random() - 0.5)
                                                        * (effectType === "splash" ? 56 : 28),
                                             "effectY": centerY + (Math.random() - 0.5)
                                                        * (effectType === "splash" ? 18 : 10),
                                             "driftX": (Math.random() - 0.5)
                                                       * (effectType === "splash" ? 96 : 32),
                                             "driftY": -8 - Math.random()
                                                       * (effectType === "splash" ? 40 : 14),
                                             "effectSize": effectType === "splash"
                                                           ? 9 + Math.random() * 13
                                                           : 6 + Math.random() * 8,
                                             "effectColor": effectType === "splash"
                                                            ? (Math.random() > 0.5 ? "#9fe8ff" : "#55cfff")
                                                            : "#d8c099"
                                         })
            }
        }

        function onSimulateEnabledChanged() {
            if (game.simulateEnabled) {
                impactEffectModel.clear()
            }
        }
    }

    Timer {
        interval: 150
        repeat: true
        running: true

        onTriggered: displayedVelocity = latestVelocity
    }

    HoverHelpTooltip {
        id: controlHelpTooltip
        // Sample the main scene so the tooltip keeps the same frosted style as the rest of the UI.
        blurSourceItem: gameElements
    }

    WindCompassPopup {
        id: windCompassPopup
        // Reuse the same scene blur source so the compass popup matches the HUD.
        blurSourceItem: gameElements
        targetItem: windDirectionCard
        windAngle: game.windAngle
        arrowRotation: game.windCompassRotation
        windSpeed: game.windVelocity
        cardinalDirection: game.windCardinalDirection
        cardinalShort: game.windCardinalShort
        // Keep the popup open while the mouse is over the trigger card or the popup itself.
        shown: windDirectionHover.containsMouse || hovered
    }

    Item {
        id: gameElements

        height: 832
        width: 1280

        Image {
            id: sky

            y: -64
            visible: true

            source: Qt.resolvedUrl("assets/sky.png")
            antialiasing: false
            smooth: false
        }
        Item {
            id: tiles

            height: 832
            width: 1280

            clip: true

            MoreInfoDropdown {
                id: moreInfoDropdown
                x: 974
                y: 88
                tooltipBlurSourceItem: gameElements
                tooltipParentItem: screen
                // Keep the existing dropdown instance and reveal it from the More Info button.
                visible: screen.moreInfoOpen || opacity > 0.01
                enabled: visible
                opacity: screen.moreInfoOpen ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 140
                    }
                }
            }
        }

        MyLevel1_1 {
            id: level1
            x: 0
            y: 381
            // Show only the artwork that matches the active loaded level data.
            visible: game.currentLevel === 1
            antialiasing: false
            smooth: false
            cache: true
            fillMode: Image.PreserveAspectCrop
        }

        MyLevel2 {
            id: level2
            x: 0
            y: 185
            // Show only the artwork that matches the active loaded level data.
            visible: game.currentLevel === 2
        }

        Repeater {
            model: impactEffectModel

            Rectangle {
                id: impactBurst
                x: effectX - width / 2
                y: effectY - height / 2
                width: effectSize
                height: effectSize
                radius: width / 2
                color: effectColor
                opacity: effectType === "splash" ? 0.95 : 0.85
                antialiasing: true
                scale: effectType === "splash" ? 0.75 : 0.6

                ParallelAnimation {
                    running: true

                    NumberAnimation {
                        target: impactBurst
                        property: "x"
                        to: impactBurst.x + driftX
                        duration: effectType === "splash" ? 620 : 420
                    }

                    NumberAnimation {
                        target: impactBurst
                        property: "y"
                        to: impactBurst.y + driftY
                        duration: effectType === "splash" ? 620 : 420
                    }

                    NumberAnimation {
                        target: impactBurst
                        property: "opacity"
                        to: 0
                        duration: effectType === "splash" ? 620 : 420
                    }

                    NumberAnimation {
                        target: impactBurst
                        property: "scale"
                        to: effectType === "splash" ? 1.9 : 1.4
                        duration: effectType === "splash" ? 620 : 420
                    }
                }
            }
        }

        MyRocket {
            id: rocket
            x: 127
            y: 460
            transformOrigin: Item.Center
            // Keep the sprite bound to controller state so reset cannot break the binding.
            rotation: game.projectileRotation

            Behavior on rotation {
                NumberAnimation {
                    duration: 80
                }
            }
        }
    }

    Results {
        id: results
        x: 339
        y: 285
        width: 400
        height: 262
        // Show the results panel after either a win or a loss.
        visible: game.resultsVisible
        tooltipBlurSourceItem: gameElements
        tooltipParentItem: screen
        // Reuse the existing Results.ui.qml component and feed it live controller values.
        flightTimeText: game.flightTime.toFixed(1) + "s"
        maxHeightText: game.maxHeight.toFixed(1) + "m"
        attemptsText: game.attempts.toString()
        totalDisplacementText: game.totalDisplacement.toFixed(1) + "m"
    }

    Item {
        id: bottomBar

        y: 631

        height: 201
        width: 1280

        clip: true

        ShaderEffectSource {
            id: blurSource
            sourceItem: gameElements

            x: configBar.x
            y: configBar.y
            width: configBar.width
            height: configBar.height

            sourceRect: Qt.rect(configBar.x, bottomBar.y + configBar.y,
                                configBar.width, configBar.height)
        }

        MultiEffect {
            x: configBar.x
            y: configBar.y
            width: configBar.width
            height: configBar.height
            brightness: -0.4
            source: blurSource
            blurEnabled: true
            blur: 1
        }

        Rectangle {
            id: configBar

            x: 196
            y: 20.50

            height: 160
            width: 888

            clip: true
            color: "#d3212741"
            radius: 10
            smooth: false
            antialiasing: false

            Rectangle {
                id: angleTitle

                x: 7
                y: 9

                height: 37
                width: 175

                color: "#212741"
                radius: 9

                CardHoverEffect {
                    anchors.fill: parent
                    cornerRadius: parent.radius
                    hovered: angleTitleHover.containsMouse
                }

                Item {
                    id: sync

                    height: 0
                    width: 0

                    Rectangle {
                        id: bounding_box

                        height: 0
                        width: 0

                        color: "#d9d9d9"
                    }
                    Shape {
                        id: sync_1

                        height: 0
                        width: 0

                        ShapePath {
                            id: sync_1_ShapePath0

                            fillColor: "#ffffff"
                            fillRule: ShapePath.WindingFill
                            joinStyle: ShapePath.MiterJoin
                            strokeColor: "#00000000"
                            strokeStyle: ShapePath.SolidLine
                            strokeWidth: 0.03

                            PathSvg {
                                id: sync_1_ShapePath0_PathSvg0

                                path: "M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z"
                            }
                        }
                    }
                }
                Item {
                    id: textContainer

                    x: 15
                    y: 8

                    height: 21
                    z: 1
                    width: 113

                    clip: true

                    Item {
                        id: frame_1

                        x: 4

                        height: 21
                        width: 105

                        Text {
                            id: title

                            height: 21
                            width: 106

                            color: "#ffffff"
                            font.capitalization: Font.AllUppercase
                            font.family: "Interstate"
                            font.pixelSize: 15
                            font.weight: Font.Normal
                            horizontalAlignment: Text.AlignHCenter
                            text: "Angle"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                Image {
                    id: image
                    width: 175
                    height: 37
                    source: "assets/TitleRED.svg"
                    cache: false
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea {
                    id: angleTitleHover
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    hoverEnabled: true
                }

                Connections {
                    target: angleTitleHover

                    // Hover help explains the dial in student-friendly language.
                    function onEntered() {
                        controlHelpTooltip.targetItem = angleTitle
                        controlHelpTooltip.heading = "Angle"
                        controlHelpTooltip.body = "Angle tells us how tilted the launch is. A larger angle sends the projectile towards the right, while a smaller angle sends it to the left. Turn the dial to choose the launch angle you want to test."
                        controlHelpTooltip.shown = true
                    }

                    function onExited() {
                        controlHelpTooltip.shown = false
                    }
                }
            }
            Rectangle {
                id: velocityTitle

                x: 192
                y: 9

                height: 37
                width: 175

                clip: true
                color: "#212741"
                radius: 9

                CardHoverEffect {
                    anchors.fill: parent
                    cornerRadius: parent.radius
                    hovered: velocityTitleHover.containsMouse
                }

                Image {
                    id: titleBlue
                    width: 175
                    height: 37
                    source: "assets/TitleBLUE.svg"
                    cache: false
                    fillMode: Image.PreserveAspectFit
                }
                Item {
                    id: sync_2

                    height: 0
                    width: 0

                    Rectangle {
                        id: bounding_box_1

                        height: 0
                        width: 0

                        color: "#d9d9d9"
                    }
                    Shape {
                        id: _vector

                        height: 0
                        width: 0

                        ShapePath {
                            id: _vector_ShapePath0

                            fillColor: "#ffffff"
                            fillRule: ShapePath.WindingFill
                            joinStyle: ShapePath.MiterJoin
                            strokeColor: "#00000000"
                            strokeStyle: ShapePath.SolidLine
                            strokeWidth: 0.03

                            PathSvg {
                                id: _vector_ShapePath0_PathSvg0

                                path: "M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z"
                            }
                        }
                    }
                }
                Item {
                    id: textContainer_1

                    x: 15
                    y: 8

                    height: 21
                    width: 113

                    clip: true

                    Item {
                        id: frame_2

                        x: 4

                        height: 21
                        width: 105

                        Text {
                            id: title_1
                            x: 0
                            y: 0

                            height: 21
                            width: 126

                            color: "#ffffff"
                            font.capitalization: Font.AllUppercase
                            font.family: "Interstate"
                            font.pixelSize: 15
                            font.weight: Font.Normal
                            horizontalAlignment: Text.AlignHCenter
                            text: "Velocity"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                MouseArea {
                    id: velocityTitleHover
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    hoverEnabled: true
                }

                Connections {
                    target: velocityTitleHover

                    // Hover help explains how the speed slider changes the launch.
                    function onEntered() {
                        controlHelpTooltip.targetItem = velocityTitle
                        controlHelpTooltip.heading = "Velocity"
                        controlHelpTooltip.body = "Velocity tells us how fast something is moving and the direction it is travelling in. Move the slider to change how fast the projectile launches."
                        controlHelpTooltip.shown = true
                    }

                    function onExited() {
                        controlHelpTooltip.shown = false
                    }
                }
            }
            Rectangle {
                id: gravityTitle

                x: 377
                y: 9

                height: 37
                width: 175

                clip: true
                color: "#212741"
                radius: 9

                CardHoverEffect {
                    anchors.fill: parent
                    cornerRadius: parent.radius
                    hovered: gravityTitleHover.containsMouse
                }

                Image {
                    id: titleYellow
                    width: 175
                    height: 37
                    source: "assets/TitleYellow.svg"
                    cache: false
                    fillMode: Image.PreserveAspectFit
                }
                Item {
                    id: sync_3

                    height: 0
                    width: 0

                    Rectangle {
                        id: bounding_box_2

                        height: 0
                        width: 0

                        color: "#d9d9d9"
                    }
                    Shape {
                        id: _vector_1

                        height: 0
                        width: 0

                        ShapePath {
                            id: _vector_1_ShapePath0

                            fillColor: "#ffffff"
                            fillRule: ShapePath.WindingFill
                            joinStyle: ShapePath.MiterJoin
                            strokeColor: "#00000000"
                            strokeStyle: ShapePath.SolidLine
                            strokeWidth: 0.03

                            PathSvg {
                                id: _vector_1_ShapePath0_PathSvg0

                                path: "M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z"
                            }
                        }
                    }
                }
                Item {
                    id: textContainer_2

                    x: 15
                    y: 8

                    height: 21
                    width: 113

                    clip: true

                    Item {
                        id: frame_3

                        x: 4

                        height: 21
                        width: 105

                        Text {
                            id: title_2
                            x: 0
                            y: 0

                            height: 21
                            width: 120

                            color: "#ffffff"
                            font.capitalization: Font.AllUppercase
                            font.family: "Interstate"
                            font.pixelSize: 15
                            font.weight: Font.Normal
                            horizontalAlignment: Text.AlignHCenter
                            text: "Gravity"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                MouseArea {
                    id: gravityTitleHover
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    hoverEnabled: true
                }

                Connections {
                    target: gravityTitleHover

                    // Hover help explains what gravity does to the projectile.
                    function onEntered() {
                        controlHelpTooltip.targetItem = gravityTitle
                        controlHelpTooltip.heading = "Gravity"
                        controlHelpTooltip.body = "Gravity is the force that pulls objects down toward the ground. Increase this to make the projectile fall faster, or lower it to let the projectile stay up longer."
                        controlHelpTooltip.shown = true
                    }

                    function onExited() {
                        controlHelpTooltip.shown = false
                    }
                }
            }
            Title {
                id: simulationcontrolsTitle
                x: 562
                y: 9
                hovered: simulationControlsHover.containsMouse

                MouseArea {
                    id: simulationControlsHover
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    hoverEnabled: true
                }

                Connections {
                    target: simulationControlsHover

                    // Hover help gives a simple overview of the whole settings panel.
                    function onEntered() {
                        controlHelpTooltip.targetItem = simulationcontrolsTitle
                        controlHelpTooltip.heading = "Simulation Controls"
                        controlHelpTooltip.body = "Use this panel to set up your launch. Choose the angle, speed and gravity, then press Simulate to test your parameters. Press Reload to reset and try again."
                        controlHelpTooltip.shown = true
                    }

                    function onExited() {
                        controlHelpTooltip.shown = false
                    }
                }
            }

            BarBusyIndicator {
                anchors.centerIn: parent
                visible: !game.simulateEnabled
                anchors.verticalCenterOffset: 47
                anchors.horizontalCenterOffset: 240
            }

            Dial {
                id: angleDial
                x: 85
                y: 52
                width: 86
                height: 86
                value: game.angle
                wheelEnabled: true
                inputMode: Dial.Circular
                stepSize: 1
                snapMode: Dial.SnapAlways
                to: 180
                from: 0
                smooth: true
                onValueChanged: game.angle = value

                background: Rectangle {
                    implicitWidth: 86
                    implicitHeight: 86
                    radius: width / 2
                    color: "#15ffffff"
                    border.color: "#f2ffffff"
                    border.width: 4

                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width - 24
                        height: width
                        radius: width / 2
                        color: "#0affffff"
                        border.color: "#55ffffff"
                        border.width: 1
                    }
                }

                handle: Rectangle {
                    width: 18
                    height: 18
                    radius: 9
                    color: "#ffffff"
                    border.color: "#d8e3f0"
                    border.width: 1
                    antialiasing: true

                    x: angleDial.width / 2 - width / 2
                    y: angleDial.height / 2 - height / 2
                    transform: [
                        Translate {
                            y: -angleDial.height * 0.34
                        },
                        Rotation {
                            angle: angleDial.angle
                            origin.x: 9
                            origin.y: 9
                        }
                    ]
                }
            }

            Slider {

                id: velocitySlider
                x: 192
                y: 96
                width: 175
                height: 26
                value: 1
                snapMode: RangeSlider.SnapAlways
                stepSize: 0.1
                to: 20
                from: 0
                onValueChanged: game.velocity = value

                background: Rectangle {
                    x: velocitySlider.leftPadding
                    y: velocitySlider.topPadding + velocitySlider.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 4
                    width: velocitySlider.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: "#bdbebf"

                    Rectangle {
                        width: velocitySlider.visualPosition * parent.width
                        height: parent.height
                        color: "#4a6dbe"
                        radius: 2
                    }
                }

                handle: Rectangle {
                    x: velocitySlider.leftPadding + velocitySlider.visualPosition
                       * (velocitySlider.availableWidth - width)
                    y: velocitySlider.topPadding + velocitySlider.availableHeight / 2 - height / 2
                    implicitWidth: 26
                    implicitHeight: 26
                    radius: 13
                    color: velocitySlider.pressed ? "#f0f0f0" : "#f6f6f6"
                    border.color: "#bdbebf"
                }
            }

            Rectangle {
                id: velocityText
                x: 192
                y: 58

                height: 23
                width: 175

                clip: true
                color: "#212741"
                radius: 9
                border.color: "#7dffffff"
                border.width: 2
                antialiasing: true
                smooth: true

                Text {
                    id: velocityTextbox
                    x: 35
                    y: 2

                    height: 21
                    width: 106

                    color: "#ffffff"
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignHCenter
                    text: velocitySlider.value.toFixed(1) + " m/s"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                id: gravityText
                x: 377
                y: 58
                width: 175
                height: 23
                color: "#212741"
                radius: 9
                border.color: "#7dffffff"
                border.width: 2
                smooth: true
                Text {
                    id: gravityTextbox
                    x: 35
                    y: 2
                    width: 106
                    height: 21
                    color: "#ffffff"
                    text: gravitySlider.value.toFixed(1) + " m/s"
                    font.pixelSize: 15
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.PlainText
                    font.weight: Font.Normal
                    font.family: "Interstate"
                }
                clip: true
                antialiasing: true
            }

            Slider {
                id: gravitySlider
                x: 377
                y: 96
                width: 175
                height: 26
                value: game.gravity
                onValueChanged: game.gravity = value
                stepSize: 0.1
                snapMode: RangeSlider.SnapAlways
                handle: Rectangle {
                    x: gravitySlider.leftPadding + gravitySlider.visualPosition
                       * (gravitySlider.availableWidth - width)
                    y: gravitySlider.topPadding + gravitySlider.availableHeight / 2 - height / 2
                    color: gravitySlider.pressed ? "#f0f0f0" : "#f6f6f6"
                    radius: 13
                    border.color: "#bdbebf"
                    implicitWidth: 26
                    implicitHeight: 26
                }
                background: Rectangle {
                    x: gravitySlider.leftPadding
                    y: gravitySlider.topPadding + gravitySlider.availableHeight / 2 - height / 2
                    width: gravitySlider.availableWidth
                    height: implicitHeight
                    color: "#bdbebf"
                    radius: 2
                    implicitWidth: 200
                    implicitHeight: 4
                    Rectangle {
                        width: gravitySlider.visualPosition * parent.width
                        height: parent.height
                        color: "#4a6dbe"
                        radius: 2
                    }
                }
                to: -10
                from: 10
            }

            Rectangle {
                id: angleText
                x: 8
                y: 52
                width: 71
                height: 23
                color: "#212741"
                radius: 9
                border.color: "#7dffffff"
                border.width: 2
                smooth: true
                Text {
                    id: angleTextbox
                    x: 0
                    y: 2
                    width: 71
                    height: 21
                    color: "#ffffff"
                    text: angleDial.value.toFixed(0) + "°"
                    font.pixelSize: 15
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.PlainText
                    font.weight: Font.Normal
                    font.family: "Interstate"
                }
                clip: true
                antialiasing: true
            }

            ControlsButton {
                id: controlsButton1
                x: 587
                y: 60
                enabled: game.simulateEnabled
                Connections {
                    target: controlsButton1
                    function onClicked() {
                        controlsButton1.state = "Status=Pressed"
                        game.startSimulation(velocitySlider.value,
                                             angleDial.value,
                                             gravitySlider.value)
                    }
                }
                buttonTextPressed: "Simulate"
                buttonTextDisabled: "Simulating"
                buttonText: "Simulate"
            }

            ReloadButton {
                id: reloadButton1
                x: 803
                y: 62

                Connections {
                    target: reloadButton1
                    function onClicked() {
                        game.resetSimulation()
                    }
                }
            }
        }

        MultiEffect {
            source: MyLevel1_1
            anchors.fill: MyLevel1_1
            blurEnabled: true
            blur: 9
        }

        Text {
            id: velocityTextboxRange0
            x: 391
            y: 143
            width: 53
            height: 21
            color: "#ffffff"
            text: "Slower"
            font.pixelSize: 15
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            textFormat: Text.PlainText
            font.weight: Font.Normal
            font.family: "Interstate"
        }

        Text {
            id: velocityTextboxRange1
            x: 507
            y: 143
            width: 53
            height: 21
            color: "#ffffff"
            text: "Faster"
            font.pixelSize: 15
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            textFormat: Text.PlainText
            font.weight: Font.Normal
            font.family: "Interstate"
        }

        Text {
            id: gravityTextboxRange2
            x: 575
            y: 143
            width: 53
            height: 21
            color: "#ffffff"
            text: "Less"
            font.pixelSize: 15
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            textFormat: Text.PlainText
            font.weight: Font.Normal
            font.family: "Interstate"
        }

        Text {
            id: gravityTextboxRange3
            x: 691
            y: 143
            width: 53
            height: 21
            color: "#ffffff"
            text: "More"
            font.pixelSize: 15
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            textFormat: Text.PlainText
            font.weight: Font.Normal
            font.family: "Interstate"
        }
    }

    Item {
        id: debugLayer
        visible: game.debugBoxEnabled
        anchors.fill: parent
        z: 5

        Repeater {
            model: debugBoxes

            Rectangle {
                x: modelData.x
                y: modelData.y
                width: modelData.width
                height: modelData.height
                transformOrigin: Item.Center
                rotation: modelData.Rotation
                color: "transparent"
                border.color: "red"
                border.width: 2
            }
        }
    }

    Item {
        id: topBarContainer

        height: 90
        width: 1280

        clip: false

        Item {
            id: leftTab

            height: 90
            width: 292

            clip: true

            Rectangle {
                id: scoreLevel

                x: 22
                y: 16

                height: 58
                width: 184

                clip: true
                color: "#e5212741"
                radius: 10

                CardHoverEffect {
                    anchors.fill: parent
                    cornerRadius: parent.radius
                    hovered: scoreLevelHover.containsMouse
                }

                Item {
                    id: level

                    x: 15
                    y: 10

                    height: 38
                    width: 65

                    clip: true

                    Text {
                        id: title_4

                        x: 1

                        height: 21
                        width: 64

                        color: "#ffffff"
                        font.capitalization: Font.AllUppercase
                        font.family: "Interstate"
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignLeft
                        text: "Level"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                    Text {
                        id: levelCounter

                        x: 1
                        y: 21

                        height: 17
                        width: 64

                        color: "#ffc059"
                        font.family: "Interstate"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignLeft
                        text: game.currentLevel.toString()
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                Image {
                    id: divider

                    x: 70
                    y: 29

                    rotation: 90
                    source: Qt.resolvedUrl("assets/divider.png")
                }
                Item {
                    id: score

                    x: 104
                    y: 10

                    height: 38
                    width: 65

                    clip: true

                    Text {
                        id: score_1

                        x: 1

                        height: 21
                        width: 64

                        color: "#ffffff"
                        font.capitalization: Font.AllUppercase
                        font.family: "Interstate"
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignLeft
                        text: "Score"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                    Text {
                        id: element

                        x: 1
                        y: 21

                        height: 17
                        width: 64

                        color: "#ff5959"
                        font.family: "Interstate"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignLeft
                        // Keep the existing score UI in sync with controller state.
                        text: game.score.toString()
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                MouseArea {
                    id: scoreLevelHover
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    hoverEnabled: true
                }
            }
        }
        Item {
            id: middleTab

            x: 308
            y: 0

            height: 90
            width: 740

            clip: true

            Rectangle {
                id: currentVelocity

                x: 11.50
                y: 16

                height: 58
                opacity: 1
                width: 155

                clip: true
                color: "#e6212741"
                radius: 10

                CardHoverEffect {
                    anchors.fill: parent
                    cornerRadius: parent.radius
                    hovered: currentVelocityHover.containsMouse
                }

                Item {
                    id: bolt

                    x: 15
                    y: 16

                    height: 26
                    width: 26

                    clip: true

                    Shape {
                        id: _vector_3

                        x: 3.25
                        y: 2.17

                        height: 21.67
                        antialiasing: true
                        width: 19.50

                        ShapePath {
                            id: _vector_3_ShapePath0

                            fillColor: "#4df4ff"
                            fillRule: ShapePath.WindingFill
                            joinStyle: ShapePath.MiterJoin
                            strokeColor: "#00000000"
                            strokeStyle: ShapePath.SolidLine
                            strokeWidth: 0.03

                            PathSvg {
                                id: _vector_3_ShapePath0_PathSvg0

                                path: "M 4.333333333333334 21.666667938232422 L 8.666666666666668 13.541667461395264 L 0 12.458334064483644 L 13 0 L 15.166666666666668 0 L 10.833333333333334 8.125000476837158 L 19.5 9.20833387374878 L 6.5 21.666667938232422 L 4.333333333333334 21.666667938232422 Z M 10.345833333333333 14.977084212303163 L 14.70625 10.806250634193422 L 7.420833333333333 9.885417246818543 L 9.127083333333333 6.716667060852051 L 4.79375 10.887500638961793 L 12.052083333333334 11.78125069141388 L 10.345833333333333 14.977084212303163 Z"
                            }
                        }
                    }
                }
                Item {
                    id: textContainer_4

                    x: 51
                    y: 10

                    height: 38
                    width: 112

                    clip: true

                    Text {
                        id: title_5

                        x: 1

                        height: 21
                        width: 124

                        color: "#ffffff"
                        font.capitalization: Font.AllUppercase
                        font.family: "Interstate"
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignLeft
                        text: "Velocity"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }

                    Text {
                        id: currentVelocity_1

                        x: 1
                        y: 21

                        height: 17
                        width: 111

                        color: "#92ff92"
                        font.family: "Interstate"
                        font.pixelSize: 15
                        font.weight: Font.Normal
                        horizontalAlignment: Text.AlignLeft
                        text: screen.displayedVelocity.toFixed(1) + " m/s"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                MouseArea {
                    id: currentVelocityHover
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    hoverEnabled: true
                }

                Connections {
                    target: currentVelocityHover

                    // Explain that this card shows the live speed during flight.
                    function onEntered() {
                        controlHelpTooltip.targetItem = currentVelocity
                        controlHelpTooltip.heading = "Current Velocity"
                        controlHelpTooltip.body = "This shows how fast the projectile is moving currently. Watch this number during the simulation to see how the speed changes as the projectile travels."
                        controlHelpTooltip.shown = true
                    }

                    function onExited() {
                        controlHelpTooltip.shown = false
                    }
                }
            }
            Rectangle {
                id: launch_8

                x: 176.50
                y: 16

                height: 58
                width: 175

                clip: true
                color: "#e5212741"
                radius: 10

                CardHoverEffect {
                    anchors.fill: parent
                    cornerRadius: parent.radius
                    hovered: launchSummaryHover.containsMouse
                }

                Item {
                    id: target

                    x: 15
                    y: 15.50

                    height: 27
                    width: 27

                    clip: true

                    Shape {
                        id: _vector_4

                        x: 2.25
                        y: 2.25

                        height: 22.50
                        antialiasing: true
                        width: 22.50

                        ShapePath {
                            id: _vector_4_ShapePath0

                            fillColor: "#ff7070"
                            fillRule: ShapePath.WindingFill
                            joinStyle: ShapePath.MiterJoin
                            strokeColor: "#00000000"
                            strokeStyle: ShapePath.SolidLine
                            strokeWidth: 0.03

                            PathSvg {
                                id: _vector_4_ShapePath0_PathSvg0

                                path: "M 6.8625 21.6140625 C 5.493749964237213 21.0234375 4.303125 20.221875 3.290625 19.209375 C 2.278125 18.196875000000002 1.4765625 17.00625003576279 0.8859375 15.637500000000001 C 0.2953125 14.268749964237214 0 12.806249964237214 0 11.25 C 0 9.693750035762786 0.2953125 8.231250035762788 0.8859375 6.8625 C 1.4765625 5.493749964237213 2.278125 4.303125 3.290625 3.290625 C 4.303125 2.278125 5.493749964237213 1.4765625 6.8625 0.8859375 C 8.231250035762788 0.2953125 9.693750035762786 0 11.25 0 C 12.806249964237214 0 14.268749964237214 0.2953125 15.637500000000001 0.8859375 C 17.00625003576279 1.4765625 18.196875000000002 2.278125 19.209375 3.290625 C 20.221875 4.303125 21.0234375 5.493749964237213 21.6140625 6.8625 C 22.2046875 8.231250035762788 22.5 9.693750035762786 22.5 11.25 C 22.5 12.806249964237214 22.2046875 14.268749964237214 21.6140625 15.637500000000001 C 21.0234375 17.00625003576279 20.221875 18.196875000000002 19.209375 19.209375 C 18.196875000000002 20.221875 17.00625003576279 21.0234375 15.637500000000001 21.6140625 C 14.268749964237214 22.2046875 12.806249964237214 22.5 11.25 22.5 C 9.693750035762786 22.5 8.231250035762788 22.2046875 6.8625 21.6140625 Z M 17.634375000000002 17.634375000000002 C 19.378125 15.890625000000002 20.25 13.762500071525574 20.25 11.25 C 20.25 8.737499928474426 19.378125 6.609375000000001 17.634375000000002 4.8656250000000005 C 15.890625000000002 3.121875 13.762500071525574 2.25 11.25 2.25 C 8.737499928474426 2.25 6.609375000000001 3.121875 4.8656250000000005 4.8656250000000005 C 3.121875 6.609375000000001 2.25 8.737499928474426 2.25 11.25 C 2.25 13.762500071525574 3.121875 15.890625000000002 4.8656250000000005 17.634375000000002 C 6.609375000000001 19.378125 8.737499928474426 20.25 11.25 20.25 C 13.762500071525574 20.25 15.890625000000002 19.378125 17.634375000000002 17.634375000000002 Z M 6.46875 16.03125 C 5.1562499642372135 14.718749964237213 4.5 13.124999928474427 4.5 11.25 C 4.5 9.375000071525573 5.1562499642372135 7.7812500357627865 6.46875 6.46875 C 7.7812500357627865 5.1562499642372135 9.375000071525573 4.5 11.25 4.5 C 13.124999928474427 4.5 14.718749964237213 5.1562499642372135 16.03125 6.46875 C 17.34375003576279 7.7812500357627865 18 9.375000071525573 18 11.25 C 18 13.124999928474427 17.34375003576279 14.718749964237213 16.03125 16.03125 C 14.718749964237213 17.34375003576279 13.124999928474427 18 11.25 18 C 9.375000071525573 18 7.7812500357627865 17.34375003576279 6.46875 16.03125 Z M 14.428125 14.428125 C 15.309375017881393 13.546874982118606 15.75 12.4875 15.75 11.25 C 15.75 10.0125 15.309375017881393 8.953125017881394 14.428125 8.071875 C 13.546874982118606 7.190624982118607 12.4875 6.75 11.25 6.75 C 10.0125 6.75 8.953125017881394 7.190624982118607 8.071875 8.071875 C 7.190624982118607 8.953125017881394 6.75 10.0125 6.75 11.25 C 6.75 12.4875 7.190624982118607 13.546874982118606 8.071875 14.428125 C 8.953125017881394 15.309375017881393 10.0125 15.75 11.25 15.75 C 12.4875 15.75 13.546874982118606 15.309375017881393 14.428125 14.428125 Z M 9.660937500000001 12.8390625 C 9.220312491059305 12.398437491059305 9 11.86875 9 11.25 C 9 10.63125 9.220312491059305 10.101562508940697 9.660937500000001 9.660937500000001 C 10.101562508940697 9.220312491059305 10.63125 9 11.25 9 C 11.86875 9 12.398437491059305 9.220312491059305 12.8390625 9.660937500000001 C 13.279687508940697 10.101562508940697 13.5 10.63125 13.5 11.25 C 13.5 11.86875 13.279687508940697 12.398437491059305 12.8390625 12.8390625 C 12.398437491059305 13.279687508940697 11.86875 13.5 11.25 13.5 C 10.63125 13.5 10.101562508940697 13.279687508940697 9.660937500000001 12.8390625 Z"
                            }
                        }
                    }
                }
                Item {
                    id: textContainer_5

                    x: 52
                    y: 10

                    height: 38
                    width: 112

                    clip: true

                    Text {
                        id: title_6

                        x: 1

                        height: 21
                        width: 124

                        color: "#ffffff"
                        font.capitalization: Font.AllUppercase
                        font.family: "Interstate"
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignLeft
                        text: "Launch"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                    Text {
                        id: launch_9

                        x: 1
                        y: 21

                        height: 17
                        width: 111

                        color: "#92ff92"
                        font.family: "Interstate"
                        font.pixelSize: 15
                        font.weight: Font.Normal
                        horizontalAlignment: Text.AlignLeft
                        text: angleDial.value.toFixed(
                                  0) + "° @ " + velocitySlider.value.toFixed(
                                  1) + " m/s"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                MouseArea {
                    id: launchSummaryHover
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    hoverEnabled: true
                }

                Connections {
                    target: launchSummaryHover

                    // Explain that this card is a quick summary of the chosen launch setup.
                    function onEntered() {
                        controlHelpTooltip.targetItem = launch_8
                        controlHelpTooltip.heading = "Launch"
                        controlHelpTooltip.body = "This shows the launch parameters you input. It combines the angle and the starting speed (velocity) so you can quickly check your setup before you simulate."
                        controlHelpTooltip.shown = true
                    }

                    function onExited() {
                        controlHelpTooltip.shown = false
                    }
                }
            }
            Rectangle {
                id: gravity

                x: 361.50
                y: 16

                height: 58
                width: 155

                clip: true
                color: "#e5212741"
                radius: 10

                CardHoverEffect {
                    anchors.fill: parent
                    cornerRadius: parent.radius
                    hovered: gravityCardHover.containsMouse
                }

                Item {
                    id: globe

                    x: 15
                    y: 15.50

                    height: 27
                    width: 27

                    clip: true

                    Shape {
                        id: _vector_5

                        x: 2.25
                        y: 2.25

                        height: 22.50
                        antialiasing: true
                        width: 22.50

                        ShapePath {
                            id: _vector_5_ShapePath0

                            fillColor: "#ffd35b"
                            fillRule: ShapePath.WindingFill
                            joinStyle: ShapePath.MiterJoin
                            strokeColor: "#00000000"
                            strokeStyle: ShapePath.SolidLine
                            strokeWidth: 0.03

                            PathSvg {
                                id: _vector_5_ShapePath0_PathSvg0

                                path: "M 6.890625 21.6140625 C 5.521874964237213 21.0234375 4.326562464237213 20.217187464237213 3.3046875 19.1953125 C 2.282812535762787 18.173437535762787 1.4765625 16.978125035762787 0.8859375 15.609375 C 0.2953125 14.240624964237213 0 12.7828125 0 11.2359375 C 0 9.6890625 0.2953125 8.235937464237214 0.8859375 6.8765625 C 1.4765625 5.517187535762787 2.282812535762787 4.326562464237213 3.3046875 3.3046875 C 4.326562464237213 2.282812535762787 5.521874964237213 1.4765625 6.890625 0.8859375 C 8.259375035762787 0.2953125 9.7171875 0 11.2640625 0 C 12.8109375 0 14.264062535762786 0.2953125 15.6234375 0.8859375 C 16.982812464237213 1.4765625 18.173437535762787 2.282812535762787 19.1953125 3.3046875 C 20.217187464237213 4.326562464237213 21.0234375 5.517187535762787 21.6140625 6.8765625 C 22.2046875 8.235937464237214 22.5 9.6890625 22.5 11.2359375 C 22.5 12.7828125 22.2046875 14.240624964237213 21.6140625 15.609375 C 21.0234375 16.978125035762787 20.217187464237213 18.173437535762787 19.1953125 19.1953125 C 18.173437535762787 20.217187464237213 16.982812464237213 21.0234375 15.6234375 21.6140625 C 14.264062535762786 22.2046875 12.8109375 22.5 11.2640625 22.5 C 9.7171875 22.5 8.259375035762787 22.2046875 6.890625 21.6140625 Z M 11.25 20.19375 C 11.737500017881393 19.51875 12.159374991059304 18.815625 12.515625 18.084375 C 12.871875008940696 17.353125000000002 13.162500000000001 16.575000017881393 13.387500000000001 15.75 L 9.1125 15.75 C 9.3375 16.575000017881393 9.628124991059304 17.353125000000002 9.984375 18.084375 C 10.340625008940696 18.815625 10.762499982118607 19.51875 11.25 20.19375 Z M 8.325000000000001 19.743750000000002 C 7.987500000000001 19.125000000000004 7.6921875 18.482812482118607 7.4390625 17.8171875 C 7.1859375000000005 17.15156251788139 6.9750000000000005 16.462500017881393 6.80625 15.75 L 3.4875000000000003 15.75 C 4.031250017881394 16.68749996423721 4.7109375 17.503125017881395 5.5265625 18.196875000000002 C 6.3421875 18.89062498211861 7.275000035762788 19.406250000000004 8.325000000000001 19.743750000000002 Z M 14.175 19.743750000000002 C 15.224999964237213 19.406250000000004 16.1578125 18.89062498211861 16.9734375 18.196875000000002 C 17.7890625 17.503125017881395 18.468749982118606 16.68749996423721 19.0125 15.75 L 15.69375 15.75 C 15.525 16.462500017881393 15.3140625 17.15156251788139 15.0609375 17.8171875 C 14.807812499999999 18.482812482118607 14.512500000000001 19.125000000000004 14.175 19.743750000000002 Z M 2.53125 13.5 L 6.35625 13.5 C 6.3 13.125000008940697 6.2578125 12.7546875 6.2296875 12.3890625 C 6.2015625 12.0234375 6.1875 11.64375 6.1875 11.25 C 6.1875 10.85625 6.2015625 10.4765625 6.2296875 10.1109375 C 6.2578125 9.7453125 6.3 9.374999991059303 6.35625 9 L 2.53125 9 C 2.4375000022351743 9.374999991059303 2.367187498882413 9.7453125 2.3203125 10.1109375 C 2.273437501117587 10.4765625 2.25 10.85625 2.25 11.25 C 2.25 11.64375 2.273437501117587 12.0234375 2.3203125 12.3890625 C 2.367187498882413 12.7546875 2.4375000022351743 13.125000008940697 2.53125 13.5 Z M 8.606250000000001 13.5 L 13.89375 13.5 C 13.950000000000001 13.125000008940697 13.992187500000002 12.7546875 14.020312500000001 12.3890625 C 14.0484375 12.0234375 14.0625 11.64375 14.0625 11.25 C 14.0625 10.85625 14.0484375 10.4765625 14.020312500000001 10.1109375 C 13.992187500000002 9.7453125 13.950000000000001 9.374999991059303 13.89375 9 L 8.606250000000001 9 C 8.55 9.374999991059303 8.5078125 9.7453125 8.4796875 10.1109375 C 8.451562500000001 10.4765625 8.4375 10.85625 8.4375 11.25 C 8.4375 11.64375 8.451562500000001 12.0234375 8.4796875 12.3890625 C 8.5078125 12.7546875 8.55 13.125000008940697 8.606250000000001 13.5 Z M 16.14375 13.5 L 19.96875 13.5 C 20.062499997764824 13.125000008940697 20.132812501117588 12.7546875 20.1796875 12.3890625 C 20.226562498882412 12.0234375 20.25 11.64375 20.25 11.25 C 20.25 10.85625 20.226562498882412 10.4765625 20.1796875 10.1109375 C 20.132812501117588 9.7453125 20.062499997764824 9.374999991059303 19.96875 9 L 16.14375 9 C 16.2 9.374999991059303 16.2421875 9.7453125 16.2703125 10.1109375 C 16.2984375 10.4765625 16.3125 10.85625 16.3125 11.25 C 16.3125 11.64375 16.2984375 12.0234375 16.2703125 12.3890625 C 16.2421875 12.7546875 16.2 13.125000008940697 16.14375 13.5 Z M 15.69375 6.75 L 19.0125 6.75 C 18.468749982118606 5.8125000357627865 17.7890625 4.996874982118607 16.9734375 4.3031250000000005 C 16.1578125 3.609375017881394 15.224999964237213 3.09375 14.175 2.75625 C 14.512500000000001 3.375 14.807812499999999 4.017187517881394 15.0609375 4.6828125 C 15.3140625 5.348437482118606 15.525 6.037499982118606 15.69375 6.75 Z M 9.1125 6.75 L 13.387500000000001 6.75 C 13.162500000000001 5.924999982118607 12.871875008940696 5.1468750000000005 12.515625 4.415625 C 12.159374991059304 3.684375 11.737500017881393 2.98125 11.25 2.30625 C 10.762499982118607 2.98125 10.340625008940696 3.684375 9.984375 4.415625 C 9.628124991059304 5.1468750000000005 9.3375 5.924999982118607 9.1125 6.75 Z M 3.4875000000000003 6.75 L 6.80625 6.75 C 6.9750000000000005 6.037499982118606 7.1859375000000005 5.348437482118606 7.4390625 4.6828125 C 7.6921875 4.017187517881394 7.987500000000001 3.375 8.325000000000001 2.75625 C 7.275000035762788 3.09375 6.3421875 3.609375017881394 5.5265625 4.3031250000000005 C 4.7109375 4.996874982118607 4.031250017881394 5.8125000357627865 3.4875000000000003 6.75 Z"
                            }
                        }
                    }
                }
                Item {
                    id: textContainer_6

                    x: 52
                    y: 10

                    height: 38
                    width: 112

                    clip: true

                    Text {
                        id: title_7

                        x: 1

                        height: 21
                        width: 124

                        color: "#ffffff"
                        font.capitalization: Font.AllUppercase
                        font.family: "Interstate"
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignLeft
                        text: "gravity"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                    Text {
                        id: wind

                        x: 1
                        y: 21

                        height: 17
                        width: 70

                        color: "#92ff92"
                        font.family: "Interstate"
                        font.pixelSize: 15
                        font.weight: Font.Normal
                        horizontalAlignment: Text.AlignLeft
                        text: gravitySlider.value.toFixed(1) + " m/s"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                MouseArea {
                    id: gravityCardHover
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    hoverEnabled: true
                }

                Connections {
                    target: gravityCardHover

                    // Explain that this card shows the downward pull used in the model.
                    function onEntered() {
                        controlHelpTooltip.targetItem = gravity
                        controlHelpTooltip.heading = "Gravity"
                        controlHelpTooltip.body = "This shows the gravity setting being used in the simulation. Stronger gravity pulls the projectile down faster, so the path bends downward sooner."
                        controlHelpTooltip.shown = true
                    }

                    function onExited() {
                        controlHelpTooltip.shown = false
                    }
                }
            }

            Rectangle {
                id: gravity1
                x: 527
                y: 16
                width: 155
                height: 58
                color: "#e5212741"
                radius: 10

                CardHoverEffect {
                    anchors.fill: parent
                    cornerRadius: parent.radius
                    hovered: windCardHover.containsMouse
                }

                Item {
                    id: globe1
                    x: 15
                    y: 15.5
                    width: 27
                    height: 27

                    VectorImage {
                        id: image1
                        x: 0
                        y: 0
                        width: 27
                        height: 27
                        source: "assets/Wind.svg"
                        preferredRendererType: VectorImage.CurveRenderer
                        antialiasing: true
                        smooth: true
                        fillMode: Image.PreserveAspectFit
                    }
                    clip: true
                }

                Item {
                    id: textContainer_7
                    x: 52
                    y: 10
                    width: 76
                    height: 38
                    Text {
                        id: title_9
                        x: 1
                        y: 0
                        width: 66
                        height: 21
                        color: "#ffffff"
                        text: "Wind"
                        font.pixelSize: 15
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignTop
                        textFormat: Text.PlainText
                        font.weight: Font.Bold
                        font.family: "Interstate"
                        font.capitalization: Font.AllUppercase
                    }

                    Text {
                        id: gravity_2
                        x: 1
                        y: 21
                        width: 66
                        height: 17
                        color: "#92ff92"
                        text: game.windVelocity.toFixed(1) + " m/s"
                        font.pixelSize: 15
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        textFormat: Text.PlainText
                        font.weight: Font.Normal
                        font.family: "Interstate"
                    }
                    clip: true
                }

                VectorImage {
                    id: image2
                    x: 112
                    y: 11
                    width: 32
                    height: 33
                    source: "assets/Arrow.svg"
                    // Use the compass-adjusted rotation so the arrow and text
                    // both describe the same wind direction.
                    rotation: game.windCompassRotation
                    preferredRendererType: VectorImage.CurveRenderer
                    smooth: true
                    antialiasing: true
                    fillMode: Image.PreserveAspectFit
                }

                clip: true

                MouseArea {
                    id: windCardHover
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    hoverEnabled: true
                }

                Connections {
                    target: windCardHover

                    // Explain how wind direction and strength affect the projectile.
                    function onEntered() {
                        controlHelpTooltip.targetItem = gravity1
                        controlHelpTooltip.heading = "Wind"
                        controlHelpTooltip.body = "Wind is moving air that can push the projectile sideways or change how it travels. Read the number to see the wind strength and use the arrow to see which way the wind is blowing."
                        controlHelpTooltip.shown = true
                    }

                    function onExited() {
                        controlHelpTooltip.shown = false
                    }
                }
            }

            Rectangle {
                id: windDirectionCard
                x: 690
                y: 16
                width: 48
                height: 58
                color: "#e5212741"
                radius: 10
                clip: true

                CardHoverEffect {
                    anchors.fill: parent
                    cornerRadius: parent.radius
                    // Keep the teaching card highlighted while its popup is open.
                    hovered: windDirectionHover.containsMouse || windCompassPopup.hovered
                }

                Text {
                    id: windDirectionTitle
                    x: 0
                    y: 11
                    width: parent.width
                    height: 14
                    color: "#ffffff"
                    text: "DIR"
                    font.family: "Interstate"
                    font.pixelSize: 11
                    font.weight: Font.Bold
                    font.capitalization: Font.AllUppercase
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: windDirectionValue
                    x: 0
                    y: 27
                    width: parent.width
                    height: 18
                    color: "#92ff92"
                    text: game.windCardinalShort
                    font.family: "Interstate"
                    font.pixelSize: 12
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    id: windDirectionHover
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    hoverEnabled: true
                }
            }
        }
        Item {
            id: rightTab

            x: 914

            height: 90
            width: 366

            clip: false

            Rectangle {
                id: moreInfo

                x: 227
                y: 16

                height: 58
                width: 117

                clip: true
                color: "#e5212741"
                radius: 10

                CardHoverEffect {
                    anchors.fill: parent
                    cornerRadius: parent.radius
                    // Show an active state while the helper dropdown is open.
                    hovered: moreInfoHover.containsMouse || screen.moreInfoOpen
                }

                Item {
                    id: iNFO

                    x: 15
                    y: 14.50

                    height: 29
                    width: 29

                    clip: true

                    Shape {
                        id: _vector_6

                        x: 2.42
                        y: 2.42

                        height: 24.17
                        width: 24.17

                        ShapePath {
                            id: _vector_6_ShapePath0

                            fillColor: "#ffffff"
                            fillRule: ShapePath.WindingFill
                            joinStyle: ShapePath.MiterJoin
                            strokeColor: "#00000000"
                            strokeStyle: ShapePath.SolidLine
                            strokeWidth: 0.03

                            PathSvg {
                                id: _vector_6_ShapePath0_PathSvg0

                                path: "M 12.944270492792128 17.777603698968885 C 13.175867704119947 17.54600648764107 13.291666316986083 17.25902731411987 13.291666316986083 16.91666622161865 L 13.291666316986083 12.083333015441895 C 13.291666316986083 11.740971922940679 13.175867704119947 11.453992749419477 12.944270492792128 11.222395538091659 C 12.71267328146431 10.99079832676384 12.42569410794311 10.874999713897704 12.083333015441895 10.874999713897704 C 11.740971922940679 10.874999713897704 11.453992749419477 10.99079832676384 11.222395538091659 11.222395538091659 C 10.99079832676384 11.453992749419477 10.874999713897704 11.740971922940679 10.874999713897704 12.083333015441895 L 10.874999713897704 16.91666622161865 C 10.874999713897704 17.25902731411987 10.99079832676384 17.54600648764107 11.222395538091659 17.777603698968885 C 11.453992749419477 18.009200910296702 11.740971922940679 18.124999523162842 12.083333015441895 18.124999523162842 C 12.42569410794311 18.124999523162842 12.71267328146431 18.009200910296702 12.944270492792128 17.777603698968885 Z M 12.944270492792128 8.110937286615371 C 13.175867704119947 7.879340075287553 13.291666316986083 7.592360901766353 13.291666316986083 7.2499998092651365 C 13.291666316986083 6.90763871676392 13.175867704119947 6.62065954324272 12.944270492792128 6.389062331914902 C 12.71267328146431 6.157465120587084 12.42569410794311 6.041666507720947 12.083333015441895 6.041666507720947 C 11.740971922940679 6.041666507720947 11.453992749419477 6.157465120587084 11.222395538091659 6.389062331914902 C 10.99079832676384 6.62065954324272 10.874999713897704 6.90763871676392 10.874999713897704 7.2499998092651365 C 10.874999713897704 7.592360901766353 10.99079832676384 7.879340075287553 11.222395538091659 8.110937286615371 C 11.453992749419477 8.34253449794319 11.740971922940679 8.458333110809326 12.083333015441895 8.458333110809326 C 12.42569410794311 8.458333110809326 12.71267328146431 8.34253449794319 12.944270492792128 8.110937286615371 Z M 12.083333015441895 24.16666603088379 C 10.41180532005098 24.16666603088379 8.840972028043534 23.84947853922844 7.370833139419555 23.21510355591774 C 5.900694250795577 22.58072857260704 4.6218748784065244 21.719791095256806 3.534374907016754 20.632291123867034 C 2.446874935626983 19.544791152477263 1.5859374582767485 18.26597178008821 0.9515624749660492 16.795832891464233 C 0.31718749165534976 15.325694002840255 0 13.754860710832808 0 12.083333015441895 C 0 10.41180532005098 0.31718749165534976 8.840972028043534 0.9515624749660492 7.370833139419555 C 1.5859374582767485 5.900694250795577 2.446874935626983 4.6218748784065244 3.534374907016754 3.534374907016754 C 4.6218748784065244 2.446874935626983 5.900694250795577 1.5859374582767485 7.370833139419555 0.9515624749660492 C 8.840972028043534 0.31718749165534976 10.41180532005098 0 12.083333015441895 0 C 13.754860710832808 0 15.325694002840255 0.31718749165534976 16.795832891464233 0.9515624749660492 C 18.26597178008821 1.5859374582767485 19.544791152477263 2.446874935626983 20.632291123867034 3.534374907016754 C 21.719791095256806 4.6218748784065244 22.58072857260704 5.900694250795577 23.21510355591774 7.370833139419555 C 23.84947853922844 8.840972028043534 24.16666603088379 10.41180532005098 24.16666603088379 12.083333015441895 C 24.16666603088379 13.754860710832808 23.84947853922844 15.325694002840255 23.21510355591774 16.795832891464233 C 22.58072857260704 18.26597178008821 21.719791095256806 19.544791152477263 20.632291123867034 20.632291123867034 C 19.544791152477263 21.719791095256806 18.26597178008821 22.58072857260704 16.795832891464233 23.21510355591774 C 15.325694002840255 23.84947853922844 13.754860710832808 24.16666603088379 12.083333015441895 24.16666603088379 Z M 12.083333015441895 21.74999942779541 C 14.781944132381014 21.74999942779541 17.067707884311677 20.813541119098662 18.94062450170517 18.94062450170517 C 20.813541119098662 17.067707884311677 21.74999942779541 14.781944132381014 21.74999942779541 12.083333015441895 C 21.74999942779541 9.384721898502775 20.813541119098662 7.098958146572113 18.94062450170517 5.2260415291786195 C 17.067707884311677 3.353124911785126 14.781944132381014 2.4166666030883786 12.083333015441895 2.4166666030883786 C 9.384721898502775 2.4166666030883786 7.098958146572113 3.353124911785126 5.2260415291786195 5.2260415291786195 C 3.353124911785126 7.098958146572113 2.4166666030883786 9.384721898502775 2.4166666030883786 12.083333015441895 C 2.4166666030883786 14.781944132381014 3.353124911785126 17.067707884311677 5.2260415291786195 18.94062450170517 C 7.098958146572113 20.813541119098662 9.384721898502775 21.74999942779541 12.083333015441895 21.74999942779541 Z"
                            }
                        }
                    }
                }
                Item {
                    id: level_2

                    x: 54
                    y: 11.50

                    height: 35
                    width: 46

                    clip: true

                    Text {
                        id: title_8

                        x: 1

                        height: 35
                        width: 165

                        color: "#ffffff"
                        font.capitalization: Font.AllUppercase
                        font.family: "Interstate"
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignLeft
                        text: "mORE
iNFO"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }

                MouseArea {
                    id: moreInfoHover
                    anchors.fill: parent
                    hoverEnabled: true
                }

                Connections {
                    target: moreInfoHover

                    // Toggle the dropdown that contains the Debug Boxes switch.
                    function onClicked() {
                        screen.moreInfoOpen = !screen.moreInfoOpen
                    }
                }
            }
        }
    }

    Item {
        id: __materialLibrary__
    }

    Item {
        id: winloseContainer
        visible: game.winVisible || game.loseVisible

        Win {
            id: win
            x: 726
            y: 331
            visible: game.winVisible
            // Feed the existing win card a controller-built success message.
            bodyText: game.winMessage
        }

        Lose {
            id: lose
            x: 726
            y: 331
            visible: game.loseVisible
            // Feed the existing lose card a controller-built retry hint.
            bodyText: game.loseMessage
        }

        ControlsButton {
            id: controlsButton
            x: 786
            y: 486
            visible: game.winVisible || game.loseVisible

            buttonTextPressed: "Continue"
            buttonTextDisabled: "Continue"
            buttonText: "Continue"
        }

        Connections {
            target: controlsButton

            // Reuse the same Continue button for win and lose, then let the
            // controller choose the correct follow-up action for the attempt.
            function onClicked() {
                if (game.winVisible) {
                    game.continueAfterWin()
                } else if (game.loseVisible) {
                    game.continueAfterLose()
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0}D{i:12;invisible:true}D{i:30;invisible:true}
}
##^##*/

