//image URLs
var whiteSVG_Icon = safari.extension.baseURI + 'PiP_Toolbar_Icon_white.svg';
var blackSVG_Icon = safari.extension.baseURI + 'PiP_Toolbar_Icon.svg';

safari.self.addEventListener("message", messageHandler); // Message recieved from Swift code
window.onfocus = function() {
	previousResult = null;
	checkForVideo();
}; // Tab selected
new MutationObserver(checkForVideo).observe(document, {subtree: true, childList: true}); // DOM changed

function dispatchMessage(messageName, parameters) {
	console.log("message: " + messageName);
	console.log("found: " + parameters.found);
	safari.extension.dispatchMessage(messageName, parameters);
}

function messageHandler(event) {
    if (event.name === "enablePiP" && getVideo() != null) {
		enablePiP();
    } else if (event.name === "addCustomPiPButtonToPlayer") {
		window[event.message.callback]() //Calls the function specified as callback
    }
}

var previousResult = null;

function checkForVideo() {
	if (getVideo() != null) {
		addCustomPiPButtons();
		if (previousResult === null || previousResult === false) {
			console.log("Video found");
			dispatchMessage("videoCheck", {found: true});
		}
		previousResult = true;
	} else if (window == window.top) {
		if (previousResult === null || previousResult === true) {
			console.log("Video not found");
			dispatchMessage("videoCheck", {found: false});
		}
		previousResult = false;
	}
}

function getVideo() {
	return document.getElementsByTagName('video')[0];
}

function enablePiP() {
	getVideo().webkitSetPresentationMode('picture-in-picture');
}

//----------------- Custom Button Methods -----------------

var players = [
	{name: "YouTube", shouldAddButton: shouldAddYouTubeButton, addButton: addYouTubeButton},
	{name: "VideoJS", shouldAddButton: shouldAddVideoJSButton, addButton: addVideoJSButton},
	{name: "Netflix", shouldAddButton: shouldAddNetflixButton, addButton: addNetflixButton},
	//TODO: add other players here
];

function addCustomPiPButtons() {
	for (const player of players) {
		if (player.shouldAddButton()) {
			console.log("Adding button to player: " + player.name);
			dispatchMessage("pipCheck", {callback: player.addButton.name}) //Sets the callback to the player's addButton
		}
	}
}

//----------------- Player Implementations -------------------------

function shouldAddYouTubeButton() {
	return location.hostname.match(/^(www\.)?youtube\.com$/)
		&& document.getElementsByClassName("ytp-right-controls").length > 0
		&& document.getElementsByClassName('PiPifierButton').length == 0;
}
		
function addYouTubeButton() {
	if (!shouldAddYouTubeButton()) return;
	var button = document.createElement("button");
	button.className = "ytp-button PiPifierButton";
	button.title = "PiP (by PiPifier)";
	button.onclick = enablePiP;
	//TODO add style
	//button.style.backgroundImage = 'url('+ whiteSVG_Icon + ')';
	var buttonImage = document.createElement("img");
	buttonImage.src = whiteSVG_Icon;
	buttonImage.width = 22;
	buttonImage.height = 36;
	button.appendChild(buttonImage);
	
	document.getElementsByClassName("ytp-right-controls")[0].appendChild(button);
}


function shouldAddVideoJSButton() {
	return document.getElementsByClassName('vjs-control-bar').length > 0
		&& document.getElementsByClassName('PiPifierButton').length == 0;
}

function addVideoJSButton() {
	if (!shouldAddVideoJSButton()) return;
	var button = document.createElement("button");
	button.className = "PiPifierButton vjs-control vjs-button";
	button.title = "PiP (by PiPifier)";
	button.onclick = enablePiP;
	var buttonImage = document.createElement("img");
	buttonImage.src = whiteSVG_Icon;
	buttonImage.width = 16;
	buttonImage.height = 30;
	button.appendChild(buttonImage);
	var fullscreenButton = document.getElementsByClassName("vjs-fullscreen-control")[0];
	fullscreenButton.parentNode.insertBefore(button, fullscreenButton);
}


function shouldAddNetflixButton() {
	return location.hostname.match('netflix')
		&& document.getElementsByClassName('PiPifierButton').length == 0;
}

function addNetflixButton(timeOutCounter) {
	if (!shouldAddNetflixButton()) return;
	if (timeOutCounter == null) timeOutCounter = 0;
	var button = document.createElement("button");
	button.className = "PiPifierButton";
	button.title = "PiP (by PiPifier)";
	button.onclick = enablePiP;
	button.height = 27;
	button.width = 24;
	button.style.backgroundColor = "transparent";
	button.style.border = "none";
	button.style.height = "100%";
	var buttonImage = document.createElement("img");
	buttonImage.src = whiteSVG_Icon;
	buttonImage.width = 15;
	buttonImage.height = 27;
	buttonImage.style.verticalAlign = "middle";
	button.appendChild(buttonImage);
	var playerStatusDiv = document.getElementsByClassName("player-status")[0];
	if (playerStatusDiv == null && timeOutCounter < 3) {
		//this is needed because the div is sometimes not reachable on the first load
		console.log("Timeout needed");
		//also necessary to count up and stop at some time to avoid endless loop on main netflix page
		setTimeout(function() {addNetflixButton(timeOutCounter+1);}, 3000);
		return;
	}
	playerStatusDiv.insertBefore(button, playerStatusDiv.firstChild);
}
