//
//  ViewController.swift
//  PiPifier
//
//  Created by Arno Appenzeller on 01.08.16.
//  Copyright © 2016 APPenzeller. All rights reserved.
//

import Cocoa

class ViewController: NSViewController{
    
    
    @IBOutlet weak var customPiPButtonsButton: NSButton!
    @IBOutlet weak var activityInd: NSProgressIndicator!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customPiPButtonsButton.state = SettingsManager.shared.isCustomPiPButtonsEnabled ? NSControl.StateValue.on : NSControl.StateValue.off

        // Do any additional setup after loading the view.
    }
    

    @IBAction func customPiPButtonsButtonPressed(_ sender: NSButton) {
        SettingsManager.shared.isCustomPiPButtonsEnabled = sender.state == NSControl.StateValue.on
    }
}
