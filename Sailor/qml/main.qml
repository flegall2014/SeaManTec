import QtQuick 2.5
import QtQuick.Window 2.2

Window {
    id: mainWindow
    visible: false
    width: 360
    height: 720

    // Application data:
    property variant _appData: undefined

    // XML parser:
    XMLParser {
        id: _xmlParser
        url: "qrc:/qml/application.json"
        onDataReady: {
            // Log:
            console.log("Loaded application.json")

            // Set application data:
            _appData = JSON.parse(responseText)

            // Set title:
            mainWindow.title = _appData.appName + "/" + _appData.clientName

            // Resize:
            mainWindow.width = _appData.windowWidth
            mainWindow.height = _appData.windowHeight

            // Load main application:
            pageMgrLoader.sourceComponent = pageMgrComponent

            // Show:
            mainWindow.visible = true
        }
    }

    // Page mgr component:
    Component {
        id: pageMgrComponent

        // Page mgr:
        PageMgr {
            id: pageMgr
            anchors.fill: parent
            pages: _appData.pages
        }
    }

    // Page mgr loader:
    Loader {
        id: pageMgrLoader
        anchors.fill: parent
        onLoaded: item.initialize()
    }
}
