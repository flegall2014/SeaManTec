import QtQuick 2.5
import QtQuick.Controls 1.4
import QtLocation 5.5
import QtPositioning 5.5

Item {
    anchors.fill: parent
    clip: true
    smooth:true

    // Original location:
    property variant originalLocation: QtPositioning.coordinate(_appData.originalLat, _appData.originalLon)

    // Plugin:
    Plugin {
        id: myPlugin
        name: "mapbox"
        PluginParameter { name: "mapbox.access_token"; value: "pk.eyJ1IjoiZmxlZ2FsbDIwMTYiLCJhIjoiY2l2bzUzejExMDBtNzJvbXVlcWRqczczeCJ9.5IQTA_MJTXrewHxxBGNivQ" }
        PluginParameter { name: "mapbox.map_id"; value: "examples.map-zr0njcqy" }
    }

    // Map:
    Map {
        id: mapView
        objectName: "SailorMap"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.fill: parent
        plugin: myPlugin;
        center: originalLocation
        zoomLevel: 2

        // Zoom:
        Slider {
            id: zoomSlider;
            z: mapView.z + 3
            minimumValue: mapView.minimumZoomLevel;
            maximumValue: mapView.maximumZoomLevel;
            anchors.margins: 10
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.right: parent.right
            orientation : Qt.Vertical
            value: 10
            onValueChanged: {
                mapView.zoomLevel = value
            }
        }

        // Boat marker:
        MapQuickItem {
            id: boatMarker
            anchorPoint: Qt.point(image.width/2, image.height/2)
            sourceItem: Image {
                id: image
                source: "qrc:/icons/ico-boat.png"
            }
        }

        // Draw boat route:
        MapPolyline {
            id: polyline
            line.width: 1
            line.color: 'brown'
        }

        // Handle panning:
        function mapPanning(x, y) {
            mapView.pan(x, y)
        }

        // Handle zoom:
        function mapZoom(inOrOut) {
            if (inOrOut)
                zoomSlider.value++;
            else zoomSlider.value--;
        }

        // Get lat/lon at x/y:
        function getCoordinate(x, y)
        {
            return mapView.toCoordinate(Qt.point(x, y))
        }
    }

    // Heading label:
    Label {
        id: headingLabel
        anchors.bottom: directionLabel.top
        anchors.bottomMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 8
        font.pixelSize: 12
        font.bold: true
        text: qsTr("LABEL")
    }

    // Direction label:
    Label {
        id: directionLabel
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 8
        font.pixelSize: 12
        font.bold: true
        text: qsTr("DIRECTION")
    }

    // Update boat heading:
    function updateBoatHeading(heading)
    {
        boatMarker.rotation = _controller.nextHeading
        headingLabel.text = qsTr("HEADING: ") + _controller.nextHeading
    }

    // Update boat direction:
    function updateBoatDirection(lat, lon)
    {
        polyline.addCoordinate(QtPositioning.coordinate(_controller.nextPosition.latitude, _controller.nextPosition.longitude))
        boatMarker.coordinate = QtPositioning.coordinate(_controller.nextPosition.latitude, _controller.nextPosition.longitude)
        directionLabel.text = qsTr("DIRECTION: ") + _controller.nextPosition.latitude + " / " + _controller.nextPosition.longitude
        console.log("path length = ", polyline.pathLength())
    }
}
