//
//  ViewController.swift
//  PiPifier iOS
//
//  Created by Arno Appenzeller on 09.05.17.
//  Copyright © 2017 APPenzeller. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class ViewController: UIViewController,MFMailComposeViewControllerDelegate,SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var productIDs: Array<String> = ["PiPifier_iOS_Tea_Large","PiPifier_iOS_Tea"]
    
    var productsArray: Array<SKProduct> = []
    
    var transactionInProgress = false
    
    @IBOutlet weak var smallCupButton: UIButton!
    @IBOutlet weak var largeCupButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //enableBuyButtonsWithPrice(prices: [0.99,1.99], currencySymbol: "$")
        buyButtonLoadingState()
        requestProductInfo()
        
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
            mailComposer.setMessageBody(NSLocalizedString("Hi, \n I have some feedback for PiPifier.",comment: "pipifierFeedBackMailContetn"), isHTML: false)
            
            self.present(mailComposer, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: NSLocalizedString("Warning", comment: "warning"), message: NSLocalizedString("It looks like your device is not able to send a mail. Please check your settings and try again", comment: "mailError"), preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //----------------------------------------------------------------------------
    //MARK: - In-App Purchase methods
    
    @IBAction func buySmallTea(_ sender: UIButton) {
        buyTeaProduct(index: 0)
    }
    
    @IBAction func buyLargeTea(_ sender: UIButton) {
        buyTeaProduct(index: 1)
    }
    
    func buyTeaProduct(index:Int){
        buyButtonDisabled()
        if transactionInProgress {
            return
        }
        
        let payment = SKPayment(product: self.productsArray[index] as SKProduct)
        SKPaymentQueue.default().add(payment)
        self.transactionInProgress = true
    }

    func buyButtonLoadingState(){
        smallCupButton.setTitle("Loading...", for: .disabled)
        largeCupButton.setTitle("Loading...", for: .disabled)
        buyButtonDisabled()
    }
    
    func buyButtonFailureState(){
        smallCupButton.setTitle("Error Loading IAP 😫", for: .disabled)
        largeCupButton.setTitle("Error Loading IAP 😫", for: .disabled)
        buyButtonDisabled()
    }
    
    func enableBuyButtonsWithPrice(prices:[NSDecimalNumber],currencySymbol:String){
        smallCupButton.setTitle("Small Cup of ☕️ (\(prices[0]) \(currencySymbol)) ", for: .normal)
        largeCupButton.setTitle("Large Cup of ☕️ (\(prices[1]) \(currencySymbol)) ", for: .normal)
        buyButtonEnabled()
    }
    
    func buyButtonDisabled(){
        smallCupButton.isEnabled = false
        largeCupButton.isEnabled = false
        (smallCupButton as! RoundRectButton).borderColor = UIColor.lightGray
        (largeCupButton as! RoundRectButton).borderColor = UIColor.lightGray
    }
    
    func buyButtonEnabled(){
        smallCupButton.isEnabled = true
        largeCupButton.isEnabled = true
        (smallCupButton as! RoundRectButton).borderColor = smallCupButton.tintColor
        (largeCupButton as! RoundRectButton).borderColor = largeCupButton.tintColor
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
            buyButtonFailureState()
        }
    }
    
    
    // MARK: SKProductsRequestDelegate method implementation
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product )
            }
            
            
            let productPrices = [productsArray[0].price,productsArray[1].price]
            DispatchQueue.main.async{
                self.enableBuyButtonsWithPrice(prices: productPrices, currencySymbol:self.productsArray[0].priceLocale.currencySymbol!)
            }
        }
            
        else {
            NSLog("There are no products.")
            DispatchQueue.main.async{
                self.buyButtonFailureState()
            }
        }
        if response.invalidProductIdentifiers.count != 0 {
            NSLog(response.invalidProductIdentifiers.description)
        }
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
                    let alert = UIAlertController(title: NSLocalizedString("Thanks!", comment: "thanks"), message: NSLocalizedString("Hey it's Arno.\n I want to say a big thank you! With your tip you support me developping more cool stuff for iOS and macOS.\n Thank you for making this possible ❤️", comment: "personal notice"), preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    self.buyButtonEnabled()
                }
                
                
                
            case SKPaymentTransactionState.failed:
                NSLog("Transaction Failed");
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                
                DispatchQueue.main.async{
                  self.buyButtonEnabled()
                }
                
                
            default:
                NSLog("\(transaction.transactionState.rawValue)")
            }
        }
    }



}

