//
//  Action.js
//  PiPifier
//
//  Created by Arno Appenzeller on 09.05.17.
//  Copyright © 2017 APPenzeller. All rights reserved.
//

var PiPifierExtensionClass = function() {};

PiPifierExtensionClass.prototype = {
    
    run: function(arguments) {
        // Here, you can run code that modifies the document and/or prepares
        // things to pass to your action's native code.
        
        // We will not modify anything, but will pass the body's background
        // style to the native code.
        
        var videoCount = document.getElementsByTagName('video').length;
        //check iFrames
        if (videoCount == 0) {
            var embeddedYT = document.getElementsByClassName('youtube-player');
            if (embeddedYT.length > 0) {
                videoCount = embeddedYT[0].getElementsByTagName('video').length;
            }
        }
        
        
        arguments.completionFunction({ "videoCount" : document.getElementsByTagName('video').length})
    },
    
    finalize: function(arguments) {
        // This method is run after the native code completes.
        
        // We'll see if the native code has passed us a new background style,
        // and set it on the body.
        
        var videoOnPage = arguments["videoOnPage"];
        var errorMessage = arguments["errorMessage"];
        if (videoOnPage == 1) {
            var video;
            if (document.getElementsByTagName('video').length > 0){
                video = document.getElementsByTagName('video')[0];
            }
            //check iframe
            else{
                video = document.getElementsByClassName('youtube-player')[0].getElementsByTagName('video')[0];
            }
            video.webkitSetPresentationMode('picture-in-picture');
            
        } else {
            // If nothing's been returned to us, we'll set the background to
            // blue.
            alert("Pipifier Message: " + errorMessage);
        }
    }
    
};
    
var ExtensionPreprocessingJS = new PiPifierExtensionClass
