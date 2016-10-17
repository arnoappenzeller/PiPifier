//
//  SafariExtensionHandler.swift
//  PiPifier-Safari-Extension
//
//  Created by Arno Appenzeller on 01.08.16.
//  Copyright © 2016 APPenzeller. All rights reserved.
//

import SafariServices

enum Message: String {
	case videoCheck, addCustomPiPButtonsIfNeeded
}

class SafariExtensionHandler: SFSafariExtensionHandler {
	
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]? = nil) {
		guard let message = Message(rawValue: messageName) else {
			NSLog("INFO: unhandled message")
			return
		}
		NSLog("INFO: recieved message: \(message)")
		guard userInfo?["iframe"] as? Bool != true else {return}
		switch message {
		case .videoCheck:
			NSLog("INFO: videoCheck: \(userInfo?["found"] as? Bool ?? false)")
			StateManager.shared.videosFound[page] = userInfo?["found"] as? Bool ?? false
			SFSafariApplication.setToolbarItemsNeedUpdate()
        case .addCustomPiPButtonsIfNeeded:
            addCustomPiPButtonsIfNeeded()
		}
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
			let videoFound = StateManager.shared.videosFound[page] ?? false
			NSLog("INFO: validating toolbarItem: \(videoFound)")
			validationHandler(videoFound, "")
		}
	}
	
	func getActivePage(completionHandler: @escaping (SFSafariPage?) -> Void) {
		SFSafariApplication.getActiveWindow {$0?.getActiveTab {$0?.getActivePage(completionHandler: completionHandler)}}
	}
    
    //MARK: - customPiPButton methods
    
    func addCustomPiPButtonsIfNeeded() {
		guard SettingsManager.shared.isCustomPiPButtonsEnabled else {return}
		getActivePage {
			$0?.dispatchMessageToScript(withName: "addCustomPiPButtons", userInfo: nil)
		}
    }
	
}
