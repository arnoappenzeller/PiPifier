function runPiPifier(){
    
    var videoCount = document.getElementsByTagName('video').length;
    //check iFrames
    if (videoCount == 0) {
        var embeddedYT = document.getElementsByClassName('youtube-player');
        if (embeddedYT.length > 0) {
            videoCount = embeddedYT[0].getElementsByTagName('video').length;
        }
    }
    
    var errorMessage = "No compatible video found.\n\nPlease note that if the video is an embedded video (like Youtube player on another site) this will only work on the main page"
    if (videoCount > 0) {
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

runPiPifier();
