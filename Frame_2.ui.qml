import QtQuick
import QtQuick.Shapes

Item {
    id: frame_2

    height: 303
    width: 400

    Rectangle {
        id: launch

        x: 36
        y: 16

        height: 37
        width: 328

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

            source: Qt.resolvedUrl("assets/intersect.png")
        }
        Item {
            id: rotate_1

            x: 11
            y: 7

            height: 24
            width: 24

            clip: true

            Item {
                id: frame

                height: 24
                width: 24

                clip: true

                Shape {
                    id: _vector

                    x: 2.50
                    y: 2

                    height: 19.50
                    width: 19.50

                    ShapePath {
                        id: _vector_ShapePath0

                        fillColor: "#00000000"
                        fillRule: ShapePath.WindingFill
                        strokeColor: "#ffffff"
                        strokeWidth: 2

                        PathSvg {
                            id: _vector_ShapePath0_PathSvg0

                            path: "M 9.5 13.000288009643555 L 6.5 10.000288009643555 M 9.5 13.000288009643555 C 10.89680004119873 12.468988001346588 12.236899971961975 11.798987984657288 13.5 11.000288009643555 M 9.5 13.000288009643555 L 9.5 18.000288009643555 C 9.5 18.000288009643555 12.52999997138977 17.45028805732727 13.5 16.000288009643555 C 14.580000042915344 14.380288004875183 13.5 11.000288009643555 13.5 11.000288009643555 M 6.5 10.000288009643555 C 7.032140016555786 8.619688034057617 7.702199995517731 7.296307682991028 8.5 6.050247669219971 C 9.665199995040894 4.187237620353699 11.28760027885437 2.6532976627349854 13.213000297546387 1.5943377017974854 C 15.138400316238403 0.5353777408599854 17.30270004272461 -0.013382155972067267 19.5 0.00024784397101029754 C 19.5 2.72024787258124 18.71999979019165 7.500247955322266 13.5 11.000288009643555 M 6.5 10.000288009643555 L 1.5 10.000288009643555 C 1.5 10.000288009643555 2.049999952316284 6.970247983932495 3.5 6.000247955322266 C 5.120000004768372 4.920247912406921 8.5 6.000247955322266 8.5 6.000247955322266 M 2 14.500288009643555 C 0.5 15.760288000106812 0 19.500288009643555 0 19.500288009643555 C 0 19.500288009643555 3.740000009536743 19.000288009643555 5 17.500288009643555 C 5.709999978542328 16.6602880358696 5.6999998688697815 15.370288133621216 4.909999847412109 14.590288162231445 C 4.521309852600098 14.219288170337677 4.009289979934692 14.004887925460935 3.4722299575805664 13.988287925720215 C 2.935159981250763 13.971687925979495 2.410879999399185 14.153988003730774 2 14.500288009643555 Z"
                        }
                    }
                }
            }
        }
        Item {
            id: textContainer

            x: 35
            y: 9

            height: 21
            width: 190

            clip: true

            Item {
                id: frame_1

                x: 5.50

                height: 21
                width: 179

                Text {
                    id: title

                    height: 21
                    width: 180

                    color: "#ffffff"
                    font.capitalization: Font.AllUppercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignHCenter
                    text: "Simulation Results"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
    Rectangle {
        id: launch_1

        x: 36
        y: 60

        height: 227
        width: 328

        border.color: "#78ded5d5"
        border.width: 1
        clip: true
        color: "#e5212741"
        radius: 9

        Rectangle {
            id: launch_2

            x: 7
            y: 46

            height: 37
            width: 314

            border.color: "#78ded5d5"
            border.width: 1
            clip: true
            color: "#212741"
            radius: 9

            Rectangle {
                id: mask_1

                height: 37
                width: 314

                color: "transparent"
                radius: 9
            }
            Image {
                id: intersect_1

                source: Qt.resolvedUrl("assets/intersect_1.png")
            }
            Item {
                id: frame_3

                x: 8
                y: 6

                height: 25
                width: 25

                clip: true

                Item {
                    id: frame_4

                    x: 2.08
                    y: 2.08

                    height: 21.88
                    width: 21.88

                    clip: true

                    Shape {
                        id: _vector_1

                        x: 1.82
                        y: 1.82

                        height: 18.23
                        width: 18.23

                        ShapePath {
                            id: _vector_1_ShapePath0

                            fillColor: "#00000000"
                            fillRule: ShapePath.WindingFill
                            strokeColor: "#ffffff"
                            strokeWidth: 2

                            PathSvg {
                                id: _vector_1_ShapePath0_PathSvg0

                                path: "M 9.114583015441895 3.645833206176758 L 9.114583015441895 9.114583015441895 L 12.760416221618653 10.937499618530275 M 18.22916603088379 9.114583015441895 C 18.22916603088379 14.148384894699257 14.148384894699257 18.22916603088379 9.114583015441895 18.22916603088379 C 4.0807355013799675 18.22916603088379 0 14.148384894699257 0 9.114583015441895 C 0 4.0807355013799675 4.0807355013799675 0 9.114583015441895 0 C 14.148384894699257 0 18.22916603088379 4.0807355013799675 18.22916603088379 9.114583015441895 Z"
                            }
                        }
                    }
                }
            }
            Item {
                id: textContainer_1

                x: 43
                y: 9

                height: 21
                width: 266

                clip: true

                Text {
                    id: title_1

                    x: 1

                    height: 21
                    width: 180

                    color: "#ffffff"
                    font.capitalization: Font.AllUppercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    text: "Flight time"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    id: title_2

                    x: 133

                    height: 21
                    width: 131

                    color: "#ffffff"
                    font.capitalization: Font.AllLowercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignRight
                    text: "130s"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Rectangle {
            id: launch_3

            x: 7
            y: 90

            height: 37
            width: 314

            border.color: "#78ded5d5"
            border.width: 1
            clip: true
            color: "#212741"
            radius: 9

            Rectangle {
                id: mask_2

                height: 37
                width: 314

                color: "transparent"
                radius: 9
            }
            Image {
                id: intersect_2

                source: Qt.resolvedUrl("assets/intersect_2.png")
            }
            Item {
                id: frame_5

                x: 8
                y: 6

                height: 25
                width: 25

                clip: true

                Item {
                    id: frame_6

                    x: 1
                    y: 1

                    height: 24
                    width: 24

                    clip: true

                    Shape {
                        id: _vector_2

                        x: 3
                        y: 3

                        height: 18
                        width: 18

                        ShapePath {
                            id: _vector_2_ShapePath0

                            fillColor: "#00000000"
                            fillRule: ShapePath.WindingFill
                            strokeColor: "#ffffff"
                            strokeWidth: 2

                            PathSvg {
                                id: _vector_2_ShapePath0_PathSvg0

                                path: "M 9 15 L 9 3 M 9 15 L 6 13 M 9 15 L 12 13 M 9 3 L 6 5 M 9 3 L 12 5 M 18 0 L 0 0 M 18 18 L 0 18"
                            }
                        }
                    }
                }
            }
            Item {
                id: textContainer_2

                x: 43
                y: 9

                height: 21
                width: 266

                clip: true

                Text {
                    id: title_3

                    x: 1

                    height: 21
                    width: 180

                    color: "#ffffff"
                    font.capitalization: Font.AllUppercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    text: "MAx Height"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    id: title_4

                    x: 133

                    height: 21
                    width: 131

                    color: "#ffffff"
                    font.capitalization: Font.AllLowercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignRight
                    text: "140M"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Rectangle {
            id: launch_4

            x: 7
            y: 134

            height: 37
            width: 314

            border.color: "#78ded5d5"
            border.width: 1
            clip: true
            color: "#212741"
            radius: 9

            Rectangle {
                id: mask_3

                height: 37
                width: 314

                color: "transparent"
                radius: 9
            }
            Image {
                id: intersect_3

                source: Qt.resolvedUrl("assets/intersect_3.png")
            }
            Item {
                id: frame_7

                x: 8
                y: 6

                height: 25
                width: 25

                clip: true

                Item {
                    id: frame_8

                    x: 1
                    y: 1

                    height: 24
                    width: 24

                    clip: true

                    Shape {
                        id: _vector_3

                        x: 3
                        y: 3

                        height: 18
                        width: 19

                        ShapePath {
                            id: _vector_3_ShapePath0

                            fillColor: "#00000000"
                            fillRule: ShapePath.WindingFill
                            strokeColor: "#ffffff"
                            strokeWidth: 2

                            PathSvg {
                                id: _vector_3_ShapePath0_PathSvg0

                                path: "M 19 7 C 19 7 16.994999527931213 4.268219828605652 15.366199493408203 2.638239860534668 C 13.73729944229126 1.0082699060440063 11.48639988899231 0 9 0 C 4.029439926147461 0 0 4.029439926147461 0 9 C 0 13.970600128173828 4.029439926147461 18 9 18 C 13.103099822998047 18 16.56489908695221 15.254300117492676 17.6481990814209 11.5 M 19 7 L 19 1 M 19 7 L 13 7"
                            }
                        }
                    }
                }
            }
            Item {
                id: textContainer_3

                x: 43
                y: 9

                height: 21
                width: 266

                clip: true

                Text {
                    id: title_5

                    x: 1

                    height: 21
                    width: 180

                    color: "#ffffff"
                    font.capitalization: Font.AllUppercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    text: "Attempts"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    id: title_6

                    x: 133

                    height: 21
                    width: 131

                    color: "#ffffff"
                    font.capitalization: Font.AllUppercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignRight
                    text: "4"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        Rectangle {
            id: launch_5

            x: 7
            y: 178

            height: 37
            width: 314

            border.color: "#78ded5d5"
            border.width: 1
            clip: true
            color: "#212741"
            radius: 9

            Rectangle {
                id: mask_4

                height: 37
                width: 314

                color: "transparent"
                radius: 9
            }
            Image {
                id: intersect_4

                source: Qt.resolvedUrl("assets/intersect_4.png")
            }
            Item {
                id: frame_9

                x: 8
                y: 6

                height: 25
                width: 25

                clip: true

                Item {
                    id: frame_10

                    x: 1
                    y: 1

                    height: 24
                    width: 24

                    clip: true

                    Shape {
                        id: _vector_4

                        x: 2
                        y: 2

                        height: 20
                        width: 20

                        ShapePath {
                            id: _vector_4_ShapePath0

                            fillColor: "#00000000"
                            fillRule: ShapePath.WindingFill
                            strokeColor: "#ffffff"
                            strokeWidth: 2

                            PathSvg {
                                id: _vector_4_ShapePath0_PathSvg0

                                path: "M 20 10 L 18 10 M 20 10 C 20 15.522799968719482 15.522799968719482 20 10 20 M 20 10 C 20 4.477149963378906 15.522799968719482 0 10 0 M 17.07110023498535 17.07110023498535 L 15.656900405883789 15.656900405883789 M 2 10 L 0 10 M 0 10 C 0 15.522799968719482 4.477149963378906 20 10 20 M 0 10 C 0 4.477149963378906 4.477149963378906 0 10 0 M 4.3431501388549805 4.3431501388549805 L 2.9289298057556152 2.9289298057556152 M 10 2 L 10 0 M 15.656900405883789 4.3431501388549805 L 17.07110023498535 2.9289298057556152 M 10 20 L 10 18 M 2.9289298057556152 17.07110023498535 L 4.3431501388549805 15.656900405883789 M 10 6 L 14 10 L 10 14 L 6 10 L 10 6 Z"
                            }
                        }
                    }
                }
            }
            Item {
                id: textContainer_4

                x: 43
                y: 9

                height: 21
                width: 266

                clip: true

                Text {
                    id: title_7

                    x: 1

                    height: 21
                    width: 180

                    color: "#ffffff"
                    font.capitalization: Font.AllUppercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignLeft
                    text: "Total displacement"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    id: title_8

                    x: 133

                    height: 21
                    width: 131

                    color: "#ffffff"
                    font.capitalization: Font.AllLowercase
                    font.family: "Interstate"
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    horizontalAlignment: Text.AlignRight
                    text: "10m"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}