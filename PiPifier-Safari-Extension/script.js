
document.addEventListener("DOMContentLoaded", function(event) {
    safari.self.addEventListener("message", messageHandler);
    safari.self.addEventListener("refreshVideoState",messageHandler);
});

safari.self.addEventListener("activate", tabChanged);




function messageHandler(event)
{
    if (event.name === "enablePiP") {
        document.querySelectorAll('video')[0].webkitSetPresentationMode('picture-in-picture');
    }
    
    else if (event.name == "checkForVideo"){
        lookForVideo();
    }
}

function lookForVideo(){
    if (window == window.top){
        if (isAVideoOnPage()){
            console.log("Found a video on top");
            safari.extension.dispatchMessage("videoFound");
        }
        else{
            console.log("Found no video on top");
            safari.extension.dispatchMessage("noVideoFound");
        }
    }
    else {
        if (isAVideoOnPage()){
            console.log("Found video somewhere else");
            safari.extension.dispatchMessage("videoFound");
        }
    }
}

function tabChanged(event)
{
    console.log("Changed a tab");
    safari.extension.dispatchMessage("tabChange");
}


//checks if there is a video on the page and returns true if there is one
function isAVideoOnPage(){
    if (document.querySelectorAll("video").length > 0){
        return true;
    }
    else{
        return false;
    }
}
