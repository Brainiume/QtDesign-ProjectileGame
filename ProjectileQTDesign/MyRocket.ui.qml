import QtQuick

Image {
    id: rocket
    width: 57
    height: 142
    source: "images/Rocket.png"
    fillMode: Image.PreserveAspectFit

    Rectangle {
        id: rectangle
        x: 17
        y: 21
        width: 22
        height: 85
        visible: false
        color: "#ff0000"
    }

    Rectangle {
        id: rectangle1
        x: 2
        y: 71
        width: 52
        height: 14
        visible: false
        color: "#ff0000"
    }

    Rectangle {
        id: rectangle2
        x: 9
        y: 63
        width: 39
        height: 8
        visible: false
        color: "#ff0000"
    }

    Rectangle {
        id: rectangle3
        x: 22
        y: 3
        width: 13
        height: 18
        visible: false
        color: "#ff0000"
    }
}
