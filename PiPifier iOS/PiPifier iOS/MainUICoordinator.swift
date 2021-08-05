//
//  MainUICoordinator.swift
//  PiPifier iOS
//
//  Created by Arno Appenzeller on 26.06.20.
//  Copyright © 2020 APPenzeller. All rights reserved.
//

import UIKit
import SwiftUI
import StoreKit

struct ButtonState{
    var smallCupText = "Small cup of tea ☕️"
    var largeCupText = "Large cup of tea ☕️"
    var isLoading = true
    var showButtonAlert = false
}



class MainUICoordinator:NSObject,ObservableObject,SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    @Published var buttonState = ButtonState()
    
    override init() {
        super.init()
        print("custom init")
        SKPaymentQueue.default().add(self)
    }
    
    
    var productIDs: Array<String> = ["PiPifier_iOS_Tea_Large","PiPifier_iOS_Tea"]
    
    var productsArray: Array<SKProduct> = []
    
    var transactionInProgress = false
    
    func buySmallTea() {
        buyTeaProduct(index: 0)
    }
    
    func buyLargeTea() {
        buyTeaProduct(index: 1)
    }
    
    func buyTeaProduct(index:Int){
        buttonState.isLoading = false
        if transactionInProgress {
            return
        }
        
        let payment = SKPayment(product: self.productsArray[index] as SKProduct)
        SKPaymentQueue.default().add(payment)
        self.transactionInProgress = true
    }

    func buyButtonLoadingState(){
        buttonState.smallCupText = "Loading..."
        buttonState.largeCupText = "Loading..."
        buttonState.isLoading = true
    }
    
    func buyButtonFailureState(){
        buttonState.smallCupText = "Error Loading IAP 😫"
        buttonState.largeCupText = "Error Loading IAP 😫"
        buttonState.isLoading = true
    }
    
    func enableBuyButtonsWithPrice(prices:[NSDecimalNumber],currencySymbol:String){
        buttonState.smallCupText = "Small Cup of ☕️ (\(prices[0]) \(currencySymbol)) "
        buttonState.largeCupText = "Large Cup of ☕️ (\(prices[1]) \(currencySymbol)) "
        buttonState.isLoading = false
    }
        
        
    //MARK: In App Purchase
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
                
                self.buttonState.showButtonAlert = true
                self.buttonState.isLoading = false
                                
                
                
            case SKPaymentTransactionState.failed:
                NSLog("Transaction Failed");
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                
                DispatchQueue.main.async{
                    self.buttonState.isLoading = false
                }
                
                
            default:
                NSLog("\(transaction.transactionState.rawValue)")
            }
        }
    }
    
}
