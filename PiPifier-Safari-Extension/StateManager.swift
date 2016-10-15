//
//  StateManager.swift
//  PiPifier
//
//  Created by Arno on 05.08.16.
//  Copyright © 2016 APPenzeller. All rights reserved.
//

import Foundation

struct StateManager {
    static let shared = StateManager()
	private init() {}
    var videoFound: Bool = false
    var currentURL: URL?
    var validationHandler: ((Bool, String) -> Void)?
}
