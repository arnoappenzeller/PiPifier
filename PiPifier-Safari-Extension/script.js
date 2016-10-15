document.addEventListener("DOMContentLoaded", function() {
    safari.self.addEventListener("message", messageHandler);
    safari.self.addEventListener("refreshVideoState", messageHandler);
});

safari.self.addEventListener("activate", tabChanged);

function messageHandler(event) {
    if (event.name === "enablePiP" && getVideo() != null) {
        getVideo().webkitSetPresentationMode('picture-in-picture');
    } else if (event.name === "checkForVideo") {
        checkForVideo();
    }
}

function checkForVideo() {
	if (getVideo() != null) {
		console.log("Found a video");
		safari.extension.dispatchMessage("videoFound");
	} else if (window == window.top) {
		console.log("Found no video on top");
		safari.extension.dispatchMessage("noVideoFound");
	}
}

function tabChanged() {
    console.log("Changed tab");
    safari.extension.dispatchMessage("tabChange");
}

function getVideo() {
	return document.getElementsByTagName('video')[0];
}
