//
//  SafariExtensionHandler.swift
//  PiPifier-Safari-Extension
//
//  Created by Arno Appenzeller on 01.08.16.
//  Copyright © 2016 APPenzeller. All rights reserved.
//

import SafariServices

enum Message: String {
	case done, noVideoFound, videoFound, tabChange
}

extension String {
	static let enablePiP = "enablePiP"
	static let checkForVideo = "checkForVideo"
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
        case .done:
            NSLog("loading should be done")
		case .videoFound:
			updateState(of: page, videoFound: true)
        case .noVideoFound:
            NSLog("found no video on page")
            updateState(of: page, videoFound: false)
		case .tabChange:
			SFSafariApplication.getActivePage {
				$0?.dispatchMessageToScript(withName: .checkForVideo, userInfo: nil)
			}
		}
	}
	
    func setVideoFound(_ videoFound: Bool, on page: SFSafariPage) {
		page.getPropertiesWithCompletionHandler { senderPageProperties in
			// Get current active tab url
			SFSafariApplication.getActivePage {
				$0?.getPropertiesWithCompletionHandler {
					if $0?.url.absoluteString == senderPageProperties?.url.absoluteString {
						self.updateState(of: page, videoFound: videoFound)
					}
				}
			}
        }
    }
	
	func updateState(of page: SFSafariPage, videoFound: Bool) {
		stateManager.videoFound = videoFound
		SFSafariApplication.setToolbarItemsNeedUpdate()
    }
	
    override func toolbarItemClicked(in window: SFSafariWindow) {
		// Credits to espenbye for pointing out that this works in fullscreen as well
		// See: https://github.com/arnoappenzeller/PiPifier/issues/4
		SFSafariApplication.getActivePage {
			$0?.dispatchMessageToScript(withName: .enablePiP, userInfo: nil)
		}
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping (Bool, String) -> Void) {
        validationHandler(true, "")
    }
	
}

extension SFSafariApplication {
	class func getActivePage(completionHandler: @escaping (SFSafariPage?) -> Void) {
		getActiveWindow {
			$0?.getActiveTab {
				$0?.getActivePage(completionHandler: completionHandler)
			}
		}
	}
}
