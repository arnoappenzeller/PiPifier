//
//  StateManager.swift
//  PiPifier
//
//  Created by Arno on 05.08.16.
//  Copyright © 2016 APPenzeller. All rights reserved.
//

import SafariServices

class StateManager {
    static let shared = StateManager()
	private init() {}
	
	var videosFound: [SFSafariPage: Bool] = [:]
}
