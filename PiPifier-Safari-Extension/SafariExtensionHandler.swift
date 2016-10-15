//
//  SafariExtensionHandler.swift
//  PiPifier-Safari-Extension
//
//  Created by Arno Appenzeller on 01.08.16.
//  Copyright © 2016 APPenzeller. All rights reserved.
//

import SafariServices

enum Message: String {
	case videoFound, noVideoFound
}

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    var manualDeactivation = false
	
	var stateManager = StateManager.shared
	
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]? = nil) {
		guard let message = Message(rawValue: messageName) else {
			NSLog("unhandled message")
			return
		}
		
		switch message {
		case .videoFound:
			updateState(of: page, videoFound: true)
		case .noVideoFound:
			updateState(of: page, videoFound: false)
		}
	}
	
	func updateState(of page: SFSafariPage, videoFound: Bool) {
		stateManager.videosFound[page] = videoFound
		SFSafariApplication.setToolbarItemsNeedUpdate()
    }
	
    override func toolbarItemClicked(in window: SFSafariWindow) {
		// Credits to espenbye for pointing out that this works in fullscreen as well
		// See: https://github.com/arnoappenzeller/PiPifier/issues/4
		getActivePage {
			$0?.dispatchMessageToScript(withName: "enablePiP", userInfo: nil)
		}
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping (Bool, String) -> Void) {
		getActivePage {
			guard let page = $0 else {return}
			let videoFound = self.stateManager.videosFound[page] ?? false
			validationHandler(videoFound, "")
		}
	}
	
	func getActivePage(completionHandler: @escaping (SFSafariPage?) -> Void) {
		SFSafariApplication.getActiveWindow {$0?.getActiveTab {$0?.getActivePage(completionHandler: completionHandler)}}
	}
	
}
