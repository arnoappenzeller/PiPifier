//
//  ViewController.swift
//  PiPifier iOS
//
//  Created by Arno Appenzeller on 09.05.17.
//  Copyright © 2017 APPenzeller. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController,MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //----------------------------------------------------------------------------
    //MARK: - Mail Methods

    @IBAction func sendMail(_ sender: UIButton) {
        if (MFMailComposeViewController.canSendMail()) {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients(["support@app-enzeller.com"])
            mailComposer.setSubject(NSLocalizedString("PiPifier iOS Feedback",comment: "pipifierFeedBackMailHeader"))
            mailComposer.setMessageBody(NSLocalizedString("Hi, \n I have some feedback for PiPifier.",comment: "pipifierFeedBackMailContent"), isHTML: false)
            
            self.present(mailComposer, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: "warning"), message: NSLocalizedString("It looks like your device is not able to send an email. Please check your settings and try again.", comment: "mailError"), preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }


}

