import QtQuick 2.5

Page {
    id: mapPage
    isFirstPage: true

    // Map places:
    MapPlaces {
        id: mapPlaces
    }

    // Return next page id:
    function nextPageId()
    {
        return "PAGE2"
    }

    // Set boat rotation:
    function onNextHeadingAvailable()
    {
        mapPlaces.updateBoatHeading(_controller.nextHeading)
    }

    // Set boat position:
    function onNextPositionAvailable()
    {
        mapPlaces.updateBoatDirection( _controller.nextPosition.latitude, _controller.nextPosition.longitude)
    }

    Component.onCompleted: {
        _controller.nextHeadingAvailable.connect(onNextHeadingAvailable)
        _controller.nextPositionAvailable.connect(onNextPositionAvailable)
    }
}
