//
//  SettingsManager.swift
//  PiPifier
//
//  Created by Arno Appenzeller on 16.10.16.
//  Copyright © 2016 APPenzeller. All rights reserved.
//

import Cocoa

class SettingsManager {
    
    static let shared = SettingsManager()
    private init() {}
    
    //NOTE: replace with your own group identifier when developping for yourself
    //Don't forget to change it in the entitlements as well otherwise it can cause crashes
    let sharedUserDefaults = UserDefaults(suiteName: "group.APPenzeller.PiPifier")!
    
    let buttonEnabledKey = "customPiPButtonsEnabled"
    
    var isCustomPiPButtonsEnabled: Bool {
        get {
            return sharedUserDefaults.value(forKey: buttonEnabledKey) as? Bool ?? true //default value is on
        }
        set(value) {
            sharedUserDefaults.set(value, forKey: buttonEnabledKey)
        }
    }
}
