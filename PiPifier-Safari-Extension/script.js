safari.self.addEventListener("message", messageHandler); // Message recieved from swift code
safari.self.addEventListener("activate", checkForVideo); // Tab changed
document.addEventListener("DOMContentLoaded", checkForVideo); // DOM loaded

function dispatchMessage(messageName) {
	safari.extension.dispatchMessage(messageName);
}

function messageHandler(event) {
    if (event.name === "enablePiP" && getVideo() != null) {
        getVideo().webkitSetPresentationMode('picture-in-picture');
    }
}

function checkForVideo() {
	if (getVideo() != null) {
		console.log("Found a video");
		dispatchMessage("videoFound");
	} else if (window == window.top) {
		console.log("Found no video on top");
		dispatchMessage("noVideoFound");
	}
}

function getVideo() {
	return document.getElementsByTagName('video')[0];
}
