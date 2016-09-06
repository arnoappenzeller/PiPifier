//
//  ExtensionStateManager.swift
//  PiPifier
//
//  Created by Arno on 05.08.16.
//  Copyright © 2016 APPenzeller. All rights reserved.
//

import Foundation

class ExtensionStateManager{
    
    static let sharedInstance = ExtensionStateManager()
    
    var videoFound:Bool?
    
    var currentURL:URL?
    
    var validationHandler:((Bool, String) -> Void)?
    
    
    
}
