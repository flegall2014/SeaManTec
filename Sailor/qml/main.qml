import QtQuick 2.5
import QtQuick.Window 2.2

Window {
    id: mainWindow
    width: 650
    height: 1440
    visible: true

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

            // Log:
            console.log("Response text: " + responseText)

            // Update title:
            mainWindow.title = _appData.appName + "/" + _appData.clientName

            // Load main application:
            pageMgrLoader.sourceComponent = pageMgrComponent
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
