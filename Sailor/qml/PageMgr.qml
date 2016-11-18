import QtQuick 2.5
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
    anchors.fill: parent
    property alias pages: pageMgr.pages

    function initialize()
    {
        pageMgr.initialize()
    }

    // Main stack view:
    StackView {
        id: pageMgr
        anchors.top: parent.top
        anchors.bottom: controlArea.top
        width: parent.width

        // Pages:
        property variant pages: []

        // Current page id:
        property string currentPageId: ""
        onCurrentItemChanged: {
            if (currentItem)
                currentPageId = currentItem.pageId
        }

        // Public interface:
        signal loadFirstPage()
        signal loadNextPage()
        signal loadPreviousPage()
        signal loadPage(string pageId)

        // Initialize:
        function initialize()
        {
            if (_appData.pages.length > 0)
            {
                var page = createPage(_appData.pages[0].pageId)
                if (page)
                    push(page)
            }
        }

        // Create page:
        function createPage(pageId)
        {
            // Finalize:
            if (currentItem)
                currentItem.finalize()

            // Get page description:
            var pageDesc = getPageDesc(pageId)
            if (!pageDesc)
                return null

            // Create a new page component:
            var component = Qt.createComponent(pageDesc.url)
            if (!component)
                return null

            // Create page:
            var page = component.createObject()
            if (!page)
            {
                console.log("CREATEPAGE ERROR: ", component.errorString())
                return null
            }

            // Set page id:
            page.pageId = pageDesc.pageId

            // Set page label:
            page.pageLabel = pageDesc.pageLabel

            // Initialize page:
            page.initialize()

            return page
        }

        // Get page desc given a page id:
        function getPageDesc(pageId)
        {
            var nPages = pages.length
            for (var i=0; i<nPages; i++)
            {
                var pageDesc = pages[i]
                if (pageDesc.pageId === pageId)
                    return pageDesc
            }
            return null
        }

        // Load next page:
        function onLoadNextPage()
        {
            if (currentItem)
            {
                console.log("REQUEST TO LOAD: ", currentItem.nextPageId())
                var nextPage = createPage(currentItem.nextPageId())
                if (nextPage)
                    push(nextPage, false)
            }
        }

        // Load previous page:
        function onLoadPreviousPage()
        {
            pop()
        }

        // Load first page:
        function onLoadFirstPage()
        {
            pop(get(0))
        }

        // Load specific page:
        function onLoadPage(pageId)
        {
            var page = createPage(pageId)
            if (page)
                push(page, false)
        }

        Component.onCompleted: {
            if (pages.length > 0)
            {
                loadFirstPage.connect(onLoadFirstPage)
                loadPreviousPage.connect(onLoadPreviousPage)
                loadNextPage.connect(onLoadNextPage)
                loadPage.connect(onLoadPage)
                buttonRowLoader.sourceComponent = buttonRowComponent
            }
        }
    }

    Item {
        id: controlArea
        width: parent.width
        height: 48
        anchors.bottom: parent.bottom

        Loader {
            id: buttonRowLoader
            anchors.fill: parent
        }

        Component {
            id: buttonRowComponent
            Row {
                anchors.fill: parent

                // Exclusive group:
                ExclusiveGroup {
                    id: exclusive
                }

                // Button repeater:
                Repeater {
                    model: pages.length
                    Item {
                        width: parent.width/pages.length
                        height: parent.height
                        CustomRadioButton {
                            id: radioButton
                            text: pages[index].pageLabel
                            anchors.centerIn: parent
                            exclusiveGroup: exclusive
                            onClicked: {
                                console.log("ICI: ", index)
                                if (index === 1) {
                                    console.log("NEXT")
                                    pageMgr.loadNextPage()
                                }
                                else {
                                    console.log("PREV")
                                    pageMgr.loadPreviousPage()
                                }
                            }
                            Component.onCompleted: {
                                if (index === 0)
                                    radioButton.checked = true
                            }
                        }
                    }
                }
            }
        }
    }
}
