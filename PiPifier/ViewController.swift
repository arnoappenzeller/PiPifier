//
//  ViewController.swift
//  PiPifier
//
//  Created by Arno Appenzeller on 01.08.16.
//  Copyright © 2016 APPenzeller. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var customPiPButtonsButton: NSButton!
    
    @IBAction func customPiPButtonsButtonPressed(_ sender: NSButton) {
        SettingsManager.shared.isCustomPiPButtonsEnabled = sender.state == 1
    }
    
    override func viewDidLoad() {
        customPiPButtonsButton.state = SettingsManager.shared.isCustomPiPButtonsEnabled ? 1 : 0
    }

}
