//
//  ViewController.swift
//  PiPifier
//
//  Created by Arno Appenzeller on 01.08.16.
//  Copyright © 2016 APPenzeller. All rights reserved.
//

import Cocoa
import StoreKit

class ViewController: NSViewController,SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    var productIDs: Array<String> = []
    
    var productsArray: Array<SKProduct> = []
    
    @IBOutlet weak var customPiPButtonsButton: NSButton!
    @IBOutlet weak var activityInd: NSProgressIndicator!
    
    var transactionInProgress = false

    @IBOutlet weak var buyButton: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productIDs.append("PiPifier_Tea")
        buyButton.title = "Loading..."
        requestProductInfo()
        
        SKPaymentQueue.default().add(self)
        //buyButton.isEnabled = true
        
        customPiPButtonsButton.state = SettingsManager.shared.isCustomPiPButtonsEnabled ? 1 : 0

        // Do any additional setup after loading the view.
    }
    

    @IBAction func customPiPButtonsButtonPressed(_ sender: NSButton) {
        SettingsManager.shared.isCustomPiPButtonsEnabled = sender.state == 1
    }
    
    // MARK: - IAP stuff
    
    func showActivity(){
        activityInd.isHidden = false
        activityInd.startAnimation(nil)
        buyButton.isHidden = true
    }
    
    func hideActivity(){
        activityInd.isHidden = true
        activityInd.stopAnimation(nil)
        buyButton.isHidden = false
    }
    
    @IBAction func buyMeATea(_ sender: AnyObject) {
        if transactionInProgress {
            return
        }
        
        
        
        let alert = NSAlert()
        alert.addButton(withTitle: "Buy")
        alert.addButton(withTitle: "Cancel")
        alert.messageText = "Buy tea?"
        alert.informativeText = "Want to buy me a ☕️ of tea? 🙃"
        alert.alertStyle = .informational
        
        if alert.runModal() == NSAlertFirstButtonReturn{
            let payment = SKPayment(product: self.productsArray[0] as SKProduct)
            SKPaymentQueue.default().add(payment)
            self.transactionInProgress = true
            
            DispatchQueue.main.async {
                self.showActivity()
            }
        }
    }
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            NSLog("Cannot perform In App Purchases.")
            noIAPfound()
        }
    }
    
     // MARK: SKProductsRequestDelegate method implementation
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product )
            }
            let theProduct = productsArray[0]
            
            buyButton.title = "\(theProduct.localizedTitle) (\(theProduct.price)\(theProduct.priceLocale.currencySymbol!))"
            buyButton.isEnabled = true
        }
            
        else {
            NSLog("There are no products.")
            noIAPfound()
        }
        if response.invalidProductIdentifiers.count != 0 {
                NSLog(response.invalidProductIdentifiers.description)
        }
    }
    
    func noIAPfound(){
        buyButton.title = "You can't buy me a ☕️ of tea 😞"
        buyButton.isEnabled = false
    }
    
    // MARK: SKPaymentTransactionObserver method implementation
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                NSLog("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                
                
                DispatchQueue.main.async{
                    let alert = NSAlert()
                    alert.addButton(withTitle: "OK")
                    alert.messageText = "Thank you so much!"
                    alert.informativeText = "Thank you for your tea 🙃!"
                    alert.alertStyle = .informational
                    
                    alert.runModal()
                    self.hideActivity()
                }
                
                
                
            case SKPaymentTransactionState.failed:
                NSLog("Transaction Failed");
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                
                DispatchQueue.main.async{
                    let alert = NSAlert()
                    alert.addButton(withTitle: "OK")
                    alert.messageText = "Ouch..."
                    alert.informativeText = "Something went wrong while buying the tea! If you want to you can try it again"
                    alert.alertStyle = .warning
                    
                    alert.runModal()
                    self.hideActivity()
                }
                
                
            default:
                NSLog("\(transaction.transactionState.rawValue)")
            }
        }
    }

}
