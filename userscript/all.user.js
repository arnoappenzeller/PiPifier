// ==UserScript==
// @name         PiPifier
// @namespace    https://github.com/Willian-Zhang/PiPifier
// @version      0.2
// @description  PiPifier is an extension that lets you use every HTML5 video in Picture in Picture mode
// @author       @arno_app <https://twitter.com/arno_app>, @Cacauu_de <https://twitter.com/Cacauu_de>, @Willian <https://github.com/willian-zhang>
// @match        */*
// @grant        none
// ==/UserScript==

//image URLs
var whiteSVG_Icon = `data:image/svg+xml;utf8,<?xml version="1.0" encoding="UTF-8"?>
<svg width="671px" height="441px" viewBox="0 0 671 441" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <!-- Generator: Sketch 40.3 (33839) - http://www.bohemiancoding.com/sketch -->
    <title>PiP_Toolbar_Icon_white</title>
    <desc>Created with Sketch.</desc>
    <defs>
        <polyline id="path-1" points="617.200445 188.359322 617.200445 0 0 0 0 366.254237 252.55902 366.254237"></polyline>
        <mask id="mask-2" maskContentUnits="userSpaceOnUse" maskUnits="objectBoundingBox" x="0" y="0" width="617.200445" height="366.254237" fill="white">
            <use xlink:href="#path-1"></use>
        </mask>
    </defs>
    <g id="UI" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="PiP_Toolbar_Icon_white" transform="translate(-15.000000, -130.000000)">
            <g id="Toolbar-Icon" transform="translate(15.000000, 130.000000)">
                <use id="Combined-Shape" stroke="#FFFFFF" mask="url(#mask-2)" stroke-width="54" xlink:href="#path-1"></use>
                <rect id="Rectangle" fill="#FFFFFF" x="263.020045" y="197.328814" width="407.979955" height="243.671186"></rect>
                <path d="M166.149412,103.362155 L166.149412,245.485858 L131.742911,245.485858 L131.742911,103.706611 L89.1651635,115.230311 L149.582508,5.46510893 L209.999853,115.230311 L166.149412,103.362155 Z" id="Combined-Shape" fill="#FFFFFF" transform="translate(149.582508, 125.475483) rotate(-236.000000) translate(-149.582508, -125.475483) "></path>
            </g>
        </g>
    </g>
</svg>`;
var blackSVG_Icon = `data:image/svg+xml;utf8,<?xml version="1.0" encoding="UTF-8"?>
<svg width="701px" height="701px" viewBox="0 0 701 701" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <!-- Generator: Sketch 40.3 (33839) - http://www.bohemiancoding.com/sketch -->
    <title>PiP_Toolbar_Icon</title>
    <desc>Created with Sketch.</desc>
    <defs>
        <polyline id="path-1" points="617.200445 188.359322 617.200445 0 0 0 0 366.254237 252.55902 366.254237"></polyline>
        <mask id="mask-2" maskContentUnits="userSpaceOnUse" maskUnits="objectBoundingBox" x="0" y="0" width="617.200445" height="366.254237" fill="white">
            <use xlink:href="#path-1"></use>
        </mask>
    </defs>
    <g id="UI" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="PiP_Toolbar_Icon">
            <g id="Toolbar-Icon" transform="translate(15.000000, 130.000000)">
                <use id="Combined-Shape" stroke="#000000" mask="url(#mask-2)" stroke-width="54" xlink:href="#path-1"></use>
                <rect id="Rectangle" fill="#000000" x="263.020045" y="197.328814" width="407.979955" height="243.671186"></rect>
                <path d="M166.149412,103.362155 L166.149412,245.485858 L131.742911,245.485858 L131.742911,103.706611 L89.1651635,115.230311 L149.582508,5.46510893 L209.999853,115.230311 L166.149412,103.362155 Z" id="Combined-Shape" fill="#000000" transform="translate(149.582508, 125.475483) rotate(-236.000000) translate(-149.582508, -125.475483) "></path>
            </g>
        </g>
    </g>
</svg>`;

//safari.self.addEventListener("message", messageHandler); // Message recieved from Swift code
window.onfocus = function() {
    previousResult = null;
    checkForVideo();
}; // Tab selected
new MutationObserver(checkForVideo).observe(document, {subtree: true, childList: true}); // DOM changed

//function dispatchMessage(messageName, parameters) {
//    safari.extension.dispatchMessage(messageName, parameters);
//}

function messageHandler(event) {
    if (event.name === "enablePiP" && getVideo() != null) {
        enablePiP();
    } else if (event.name === "addCustomPiPButtonToPlayer") {
        addCustomPiPButtonToPlayer(event.message)
    }
}
function addCustomPiPButtonToPlayer(message){
    message.callback();
}

var previousResult = null;
var videoCheck = {found: true}
function checkForVideo() {
    if (getVideo() != null) {
        addCustomPiPButtons();
        if (previousResult === null || previousResult === false) {
            //dispatchMessage("videoCheck", {found: true});
            console.warn("videoCheck", {found: true})
            videoCheck = {found: true}
            enablePiP();
        }
        previousResult = true;
    } else if (window == window.top) {
        if (previousResult === null || previousResult === true) {
            //dispatchMessage("videoCheck", {found: false});
            console.warn("videoCheck", {found: false})
            videoCheck = {found: false}
        }
        previousResult = false;
    }
}

function getVideo() {
    return document.getElementsByTagName('video')[0];
}

async function action(video) {
    if (video.hasAttribute('__pip__')) {
        await document.exitPictureInPicture();
    } else {
        await video.requestPictureInPicture();
        video.setAttribute('__pip__', true);
        video.addEventListener('leavepictureinpicture', event => {
            video.removeAttribute('__pip__');
        }, {
            once: true
        });
    }
}

function enablePiP() {
    let video = getVideo()
    if(video.webkitSetPresentationMode){
        // safari
        video.webkitSetPresentationMode('picture-in-picture');
    }else{
        //chrome
        action(video);
    }
}

//----------------- Custom Button Methods -----------------

var players = [
               {name: "YouTube", shouldAddButton: shouldAddYouTubeButton, addButton: addYouTubeButton},
               {name: "VideoJS", shouldAddButton: shouldAddVideoJSButton, addButton: addVideoJSButton},
               {name: "Netflix", shouldAddButton: shouldAddNetflixButton, addButton: addNetflixButton},
               {name: "Wistia", shouldAddButton: shouldAddWistiaButton, addButton: addWistiaButton},
               //TODO: add other players here
               ];

let pipCheck = function pipCheck(message){
    addCustomPiPButtonToPlayer(message);
}
function addCustomPiPButtons() {
    for (const player of players) {
        if (player.shouldAddButton()) {
            //dispatchMessage("pipCheck", {callback: player.addButton.name}) //Sets the callback to the player's addButton
            pipCheck({callback: player.addButton});
        }
    }
}

//----------------- Player Implementations -------------------------

function shouldAddYouTubeButton() {
    //check if on youtube or player is embedded
    return (location.hostname.match(/^(www\.)?youtube\.com$/)
            || document.getElementsByClassName("ytp-right-controls").length > 0)
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

function shouldAddWistiaButton() {
    return document.getElementsByClassName('wistia_playbar').length > 0
    && document.getElementsByClassName('PiPifierButton').length == 0;
}

function addWistiaButton() {
    if (!shouldAddWistiaButton()) return;
    var button = document.createElement("button");
    button.className = "PiPifierButton w-control w-control--fullscreen w-is-visible";
    button.alt = "Picture in Picture";
    button.title = "PiP (by PiPifier)";
    button.onclick = enablePiP;
    var buttonImage = document.createElement("img");
    buttonImage.src = whiteSVG_Icon;
    buttonImage.width = 28;
    buttonImage.height = 18;
    buttonImage.style.verticalAlign = "middle";
    button.appendChild(buttonImage);
    document.getElementsByClassName("w-control-bar__region--airplay")[0].appendChild(button);
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
    button.style.backgroundColor = "transparent";
    button.style.border = "none";
    button.style.maxHeight = "inherit";
    button.style.width = "70px";
    button.style.marginRight = "2px";
    var buttonImage = document.createElement("img");
    buttonImage.src = whiteSVG_Icon;
    buttonImage.style.verticalAlign = "middle";
    buttonImage.style.maxHeight = "40%";
    button.appendChild(buttonImage);
    var playerStatusDiv = document.getElementsByClassName("player-status")[0];
    if (playerStatusDiv == null && timeOutCounter < 3) {
        //this is needed because the div is sometimes not reachable on the first load
        //also necessary to count up and stop at some time to avoid endless loop on main netflix page
        setTimeout(function() {addNetflixButton(timeOutCounter+1);}, 3000);
        return;
    }
    playerStatusDiv.insertBefore(button, playerStatusDiv.firstChild);
}