browser.browserAction.onClicked.addListener(
    function(){
        browser.tabs.executeScript({file:"content.js"});
    }
);
