import QtQuick 2.5

Image {
    id: imageButton
    fillMode: Image.PreserveAspectFit
    property string pressedUrl
    scale: mouseArea.pressed ? .97 : 1
    signal clicked()
    opacity: enabled ? 1 : .75
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: imageButton.clicked()
    }
    states: State {
        name: "pressed"
        when: mouseArea.pressed
        PropertyChanges {
            target: imageButton
            source: (pressedUrl.length === 0) ? source : pressedUrl
        }
    }
}
