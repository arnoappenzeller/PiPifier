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
}

var firstCheck = true;
var previousResult = false;

function checkForVideo() {
	if (getVideo() != null) {
		if (!previousResult) {
			previousResult = true;
			console.log("Found a video");
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
