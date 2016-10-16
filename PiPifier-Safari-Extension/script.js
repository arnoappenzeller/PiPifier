//array of supported players on domains
var isYoutube = ['youtube','youtu'];


//image URLs
var whiteSVG_Icon = safari.extension.baseURI + 'PiP_Toolbar_Icon_white.svg'
var blackSVG_Icon = safari.extension.baseURI + 'PiP_Toolbar_Icon.svg'

safari.self.addEventListener("message", messageHandler); // Message recieved from Swift code
safari.self.addEventListener("activate", checkForVideo); // Tab changed
new MutationObserver(checkForVideo).observe(document, {subtree: true, childList: true}); // DOM changed




function dispatchMessage(messageName) {
	safari.extension.dispatchMessage(messageName);
}

function messageHandler(event) {
    if (event.name === "enablePiP" && getVideo() != null) {
        getVideo().webkitSetPresentationMode('picture-in-picture');
    }
    else if (event.name === "addCustomPiPButtons"){
        checkForCustomPiPButtonSupport();
    }
}

var firstCheck = true;
var previousResult = false;


function checkForVideo() {
	if (getVideo() != null) {
		if (!previousResult) {
			previousResult = true;
			console.log("Found a video");
            shouldCustomPiPButtonsBeAdded();
			dispatchMessage("videoFound");
		}
	} else if (window == window.top) {
		if (previousResult || firstCheck) {
			previousResult = false;
			console.log("Found no video on top");
			dispatchMessage("noVideoFound");
		}
	}
	firstCheck = false;
}

function getVideo() {
	return document.getElementsByTagName('video')[0];
}


//----------------- Custom Button Methods -----------------

function shouldCustomPiPButtonsBeAdded(){
    dispatchMessage("shouldCustomPiPButtonsBeAdded");
}

function checkForCustomPiPButtonSupport(){
    //add custom eventListener for youtube
    if (isYoutube.map(function(obj){return location.hostname.match(obj) != null;}).indexOf(true) >= 0){
        addYouTubeVideoButton();
    }
    //check for videoJS player on site
    else if(document.getElementsByClassName('vjs-control-bar').length > 0){
        addVideoJSPlayerButton();
    }
    //check for other players
    //TODO: add other players here
}


//----------------- Player Implementations -------------------------
function addYouTubeVideoButton() {
    var video = document.getElementsByTagName('video')[0];
    
    
    if (video != null && document.getElementsByClassName('PiPifierButton').length == 0) {
        var button = document.createElement("button");
        button.className = "ytp-button PiPifierButton";
        button.title = "PiP (by PiPifier)";
        button.onclick = function(){document.getElementsByTagName('video')[0].webkitSetPresentationMode('picture-in-picture');};
        //TODO add style
        //button.style.backgroundImage = 'url('+ whiteSVG_Icon + ')';
        
        var buttonImage = document.createElement("img");
        buttonImage.src = whiteSVG_Icon;
        buttonImage.width = 22;
        buttonImage.height = 36;
        button.appendChild(buttonImage);
        
        document.getElementsByClassName("ytp-right-controls")[0].appendChild(button);
    }
}

function addVideoJSPlayerButton() {
    var video = document.getElementsByTagName('video')[0];
    if (video != null && document.getElementsByClassName('PiPifierButton').length == 0) {
        var button = document.createElement("button");
        button.className = "PiPifierButton vjs-control vjs-button";
        button.title = "PiP (by PiPifier)";
        button.onclick = function(){document.getElementsByTagName('video')[0].webkitSetPresentationMode('picture-in-picture');};
        
        
        var buttonImage = document.createElement("img");
        buttonImage.src = whiteSVG_Icon;
        buttonImage.width = 16;
        buttonImage.height = 30;
        button.appendChild(buttonImage);
        
        var fullscreenButton = document.getElementsByClassName("vjs-fullscreen-control")[0];
        fullscreenButton.parentNode.insertBefore(button, fullscreenButton);
    }
}
