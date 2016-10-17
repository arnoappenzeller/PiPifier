//image URLs
var whiteSVG_Icon = safari.extension.baseURI + 'PiP_Toolbar_Icon_white.svg';
var blackSVG_Icon = safari.extension.baseURI + 'PiP_Toolbar_Icon.svg';

safari.self.addEventListener("message", messageHandler); // Message recieved from Swift code
window.onfocus = checkForVideo; // Tab selected
new MutationObserver(checkForVideo).observe(document, {subtree: true, childList: true}); // DOM changed


function dispatchMessage(messageName, parameters) {
	safari.extension.dispatchMessage(messageName, parameters);
}

function messageHandler(event) {
    if (event.name === "enablePiP" && getVideo() != null) {
		enablePiP();
    } else if (event.name === "addCustomPiPButtons") {
		addCustomPiPButtons();
    }
}

function checkForVideo() {
	var found = getVideo() != null;
	if (found) {
		dispatchMessage("addCustomPiPButtonsIfNeeded");
	}
	console.log("Video " + (found ? "" : "not ") + "found");
	dispatchMessage("videoCheck", {'found': found, 'iframe': window != window.top});
}

function getVideo() {
	return document.getElementsByTagName('video')[0];
}

function enablePiP() {
	getVideo().webkitSetPresentationMode('picture-in-picture');
}

//----------------- Custom Button Methods -----------------

var players = [
	{name: "YouTube", shouldAddButton: shouldAddYouTubePiPButton, addButton: addYouTubePiPButton},
	{name: "Netflix", shouldAddButton: shouldAddNetflixPiPButton, addButton: addNetflixPiPButton},
	//TODO: add other players here
];

function addCustomPiPButtons() {
	for (const player of players) {
		if (player.shouldAddButton()) {
			console.log("Adding button to player: " + player.name);
			player.addButton();
		}
	}
}

//----------------- Player Implementations -------------------------

function shouldAddYouTubePiPButton() {
	return location.hostname.match(/^(www\.)?youtube\.com|youtu\.be$/)
		&& document.getElementsByClassName("ytp-right-controls").length > 0
		&& document.getElementsByClassName('PiPifierButton').length == 0;
}
		
function addYouTubePiPButton() {
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


function shouldAddNetflixPiPButton() {
	//TODO: method stub
	return false;
}

function addNetflixPiPButton() {
	//TODO: method stub
}
