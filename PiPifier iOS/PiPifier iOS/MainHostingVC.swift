//
//  MainHostingVC.swift
//  PiPifier iOS
//
//  Created by Arno Appenzeller on 25.06.20.
//  Copyright © 2020 APPenzeller. All rights reserved.
//

import UIKit
import SwiftUI

class MainHostingVC: UIHostingController<MainViewSwiftUI> {
    required init?(coder: NSCoder) {
            super.init(coder: coder,rootView: MainViewSwiftUI());
        }

        override func viewDidLoad() {
            super.viewDidLoad()
        }
    
}
