import QtQuick 2.5
import QtQuick.Controls 1.4
import QtLocation 5.5
import QtPositioning 5.5

Item {
    anchors.fill: parent
    clip: true
    smooth:true

    Plugin {
        id: myPlugin
        name: "here"
        PluginParameter { name: "here.app_id"; value: "PS9ASC8oCPeP6cRaf6WA" }
        PluginParameter { name: "here.token"; value: "euKy45zOAsJFgIFNlDE-ow" }
        //PluginParameter { name: "osm.useragent"; value: "map" }
        //PluginParameter { name: "osm.mapping.host"; value: "http://a.basemaps.cartocdn.com/dark_nolabels/" }
        //PluginParameter { name: "osm.mapping.copyright"; value: "All mine" }
        //PluginParameter { name: "osm.routing.host"; value: "http://osrm.server.address/viaroute" }
        //PluginParameter { name: "osm.geocoding.host"; value: "http://geocoding.server.address" }
    }

    property variant originalLocation: QtPositioning.coordinate(44.94, 14.59)

    Map {
        property variant markers
        property int markerCounter: 0 // counter for total amount of markers. Resets to 0 when number of markers = 0

        property variant popups
        property int popupCounter: 0

        property variant popup_message
        property variant popup_color

        property variant route

        id: mapView
        objectName: "SailorMap"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.fill: parent
        plugin: myPlugin;
        center: originalLocation
        zoomLevel: 2

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

        MapQuickItem {
            id: boatMarker
            anchorPoint: Qt.point(image.width/2, image.height/2)
            sourceItem: Image {
                id: image
                source: "qrc:/icons/ico-boat.png"
            }
        }

        RouteModel {
            id: routeModel
            plugin : mapView.plugin
            query:  RouteQuery {
                id: routeQuery
            }
            onStatusChanged: {
                if (status == RouteModel.Ready) {
                    switch (count) {
                    case 0:
                        // technically not an error
                        mapView.routeError()
                        break
                    case 1:
                        break
                    }
                } else if (status == RouteModel.Error) {
                    mapView.routeError()
                }
            }
        }

        MapItemView {
            model: routeModel
            delegate: routeDelegate
        }

        MapPolyline {
            id: polyline
            line.width: 1
            line.color: 'brown'

            /*
            path: [
                { latitude: -27, longitude: 153.0 },
                { latitude: -27, longitude: 154.1 },
                { latitude: -28, longitude: 153.5 },
                { latitude: -29, longitude: 153.5 }
            ]
            */
        }

        Component {
            id: routeDelegate

            MapRoute {
                id: route
                route: routeData
                line.color: "#46a2da"
                line.width: 10
                smooth: true
                opacity: 1
            }
        }

        function mapPanning(x, y) {
            mapView.pan(x, y);
        }

        function mapZoom(inOrOut) {
            if (inOrOut) {
                zoomSlider.value++;
            } else {
                zoomSlider.value--;
            }
        }

        function addMarker(x, y)
        {
            var count = mapView.markers.length
            markerCounter++
            var marker = Qt.createQmlObject ('Marker {}', mapView)
            mapView.addMapItem(marker)
            marker.z = mapView.z+1
            marker.coordinate = mapView.toCoordinate(Qt.point(x, y))
            //update list of markers
            var myArray = new Array()
            for (var i = 0; i<count; i++){
                myArray.push(markers[i])
            }
            myArray.push(marker)
            markers = myArray
            return marker.coordinate
        }

        function setPopup(color, msg)
        {
            popup_message = msg
            popup_color = color
        }

        function addPopup(x, y)
        {
            var count = mapView.popups.length
            popupCounter++
            var popup = Qt.createQmlObject ('Popup {}', mapView)
            mapView.addMapItem(popup)
            popup.z = mapView.z+1
            popup.coordinate = mapView.toCoordinate(Qt.point(x, y))
            //update list of markers
            var myArray = new Array()
            for (var i = 0; i<count; i++){
                myArray.push(popups[i])
            }
            myArray.push(popup)
            popups = myArray
        }

        function getCoordinate(x, y)
        {
            return mapView.toCoordinate(Qt.point(x, y))
        }

        function deleteMarkers()
        {
            var count = mapView.markers.length
            for (var i = 0; i<count; i++){
                mapView.removeMapItem(mapView.markers[i])
                mapView.markers[i].destroy()
            }
            mapView.markers = []
            markerCounter = 0

            zoomSlider.value = 10;
            mapView.center = originalLocation
        }

        function deletePopups()
        {
            var count = mapView.popups.length
            for (var i = 0; i<count; i++){
                mapView.removeMapItem(mapView.popups[i])
                mapView.popups[i].destroy()
            }
            mapView.popups = []
            popupCounter = 0
        }

        function startPlaces()
        {
            zoomSlider.value = 16;
            mapView.center = originalLocation
        }

        function addRoute()
        {
            var fromCoordinate = QtPositioning.coordinate(37.45, -122.16)
            var toCoordinate = QtPositioning.coordinate(37.485215,-122.236355)

            // clear away any old data in the query
            routeQuery.clearWaypoints();

            // add the start and end coords as waypoints on the route
            routeQuery.addWaypoint(fromCoordinate)
            routeQuery.addWaypoint(toCoordinate)
            routeQuery.travelModes = RouteQuery.CarTravel
            routeQuery.routeOptimizations = RouteQuery.FastestRoute

            routeModel.update();

            // center the map on the start coord
            zoomSlider.value = 12;
            mapView.center = fromCoordinate;
        }

        function removeRoute()
        {
            routeModel.reset()
            zoomSlider.value = 10;
            mapView.center = originalLocation
        }

        Component.onCompleted: {
            markers = new Array();
            popups = new Array();
        }
    }

    function onNextHeadingAvailable()
    {
        console.log("HEADING = ", _controller.nextHeading)
        boatMarker.rotation = _controller.nextHeading
    }

    function onNextPositionAvailable()
    {
        console.log("POSITION = ", _controller.nextPosition.longitude,
                    _controller.nextPosition.latitude)
        polyline.addCoordinate(QtPositioning.coordinate(_controller.nextPosition.latitude, _controller.nextPosition.longitude))
        boatMarker.coordinate = QtPositioning.coordinate(_controller.nextPosition.latitude, _controller.nextPosition.longitude)
    }

    Component.onCompleted: {
        _controller.nextHeadingAvailable.connect(onNextHeadingAvailable)
        _controller.nextPositionAvailable.connect(onNextPositionAvailable)
    }
}
