import QtQuick 2.5
import QtQuick.Controls 1.2

StackView {
    id: pageMgr

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

        // Set object name:
        page.pageId = pageDesc.pageId

        // Initialize page:
        page.initialize()

        page.backButtonClicked.connect(pageMgr.loadPreviousPage)

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
        }
    }
}
