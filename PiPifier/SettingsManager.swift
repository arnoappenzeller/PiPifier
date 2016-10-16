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
    
    //NOTE: replace with your own group identifier when developping for yourself
    //Don't forget to change it in the entitlements as well otherwise it can cause crashes
    let sharedUserDefaults = UserDefaults(suiteName: "group.APPenzeller.PiPifier")!
    
    var isCustomPiPButtonsEnabled:Bool{
        get{
            if let theBool = self.sharedUserDefaults.value(forKey: "customPiPButtonsEnabled"){
                return theBool as! Bool
            }
                //default value is on
            else{
                return true
            }
        }
        set(value){
            self.sharedUserDefaults.setValue(value, forKey: "customPiPButtonsEnabled")
        }
    }
}
