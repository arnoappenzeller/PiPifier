//
//  SafariExtensionHandler.swift
//  PiPifier-Safari-Extension
//
//  Created by Arno Appenzeller on 01.08.16.
//  Copyright © 2016 APPenzeller. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    var manualDeactivation = false
    
    let stateManager = ExtensionStateManager.sharedInstance

    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]? = nil) {
        switch messageName {
        case "done":
            NSLog("loading should be done")
        case "noVideoFound":
            NSLog("found no video on page")
            stateManager.videoFound = false
            SFSafariApplication.setToolbarItemsNeedUpdate()
        case "videoFound":
            stateManager.videoFound = true
            SFSafariApplication.setToolbarItemsNeedUpdate()
        default:
            NSLog("unhandled Message")
        }
    }
    
    
    func updateVideoFoundState(localVideoFound:Bool, on page:SFSafariPage){
        page.getPropertiesWithCompletionHandler({
            senderPageProperties in
            
            //get current active tab url
            SFSafariApplication.getActiveWindow(completionHandler: {
                $0?.getActiveTab(completionHandler: {
                    $0?.getActivePage(completionHandler: {
                        $0?.getPropertiesWithCompletionHandler({
                            activeTabPagePropeties in
                            if senderPageProperties?.url.absoluteString == activeTabPagePropeties?.url.absoluteString{
                                self.updatePageState(localVideoFound: localVideoFound,senderPageURL: senderPageProperties!.url)
                            }
                            else{
                            }
                        })
                    })
                })
            })
        })
    }
    
    func updatePageState(localVideoFound:Bool,senderPageURL:URL){
        if localVideoFound{
            stateManager.videoFound = true
            SFSafariApplication.setToolbarItemsNeedUpdate()
        }
    }
    
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        // This method will be called when your toolbar item is clicked.
        window.getActiveTab(completionHandler: {
            $0?.getActivePage(completionHandler: {
                page in
                page?.dispatchMessageToScript(withName: "enablePiP", userInfo: nil)
            })
        })
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: ((Bool, String) -> Void)) {
        validationHandler(true,"")
        
        
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }

}
