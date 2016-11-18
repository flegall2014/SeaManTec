import QtQuick 2.5

Item {
    property string pageId: ""
    property string pageLabel: ""
    property bool isFirstPage: false
    signal backButtonClicked()

    // Initialize page:
    function initialize()
    {
        // Base impl does nothing.
    }

    // Finalize page:
    function finalize()
    {
        // Base impl does nothing.
    }

    // Return next page id:
    function nextPageId()
    {
        return ""
    }

    // Back button:
    ImageButton {
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        source: "qrc:/icons/ico-navigate-back.png"
        visible: !isFirstPage
        width: 48
        fillMode: Image.PreserveAspectFit
        z: 1e9
        onClicked: backButtonClicked()
    }
}
