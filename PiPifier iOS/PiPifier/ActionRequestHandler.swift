//
//  ActionRequestHandler.swift
//  PiPifier
//
//  Created by Arno Appenzeller on 09.05.17.
//  Copyright © 2017 APPenzeller. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {

    var extensionContext: NSExtensionContext?
    
    func beginRequest(with context: NSExtensionContext) {
        // Do not call super in an Action extension with no user interface
        self.extensionContext = context
        
        var found = false
    
        
        // Find the item containing the results from the JavaScript preprocessing.
        outer:
            for item in context.inputItems as! [NSExtensionItem] {
                if let attachments = item.attachments {
                    for itemProvider in attachments {
                        if itemProvider.hasItemConformingToTypeIdentifier(String(kUTTypePropertyList)) {
                            itemProvider.loadItem(forTypeIdentifier: String(kUTTypePropertyList), options: nil, completionHandler: { (item, error) in
                                let dictionary = item as! [String: Any]
                                OperationQueue.main.addOperation {
                                    self.itemLoadCompletedWithPreprocessingResults(dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! [String: Any]? ?? [:])
                                }
                            })
                            found = true
                            break outer
                        }
                    }
                }
        }
        
        if !found {
            self.doneWithVideoFound(videoFound: false)
        }
    }
    
    func itemLoadCompletedWithPreprocessingResults(_ javaScriptPreprocessingResults: [String: Any]) {
        // Here, do something, potentially asynchronously, with the preprocessing
        // results.
        
        // In this very simple example, the JavaScript will have passed us the
        // current background color style, if there is one. We will construct a
        // dictionary to send back with a desired new background color style.
        let videoCount = javaScriptPreprocessingResults["videoCount"] as! Int
        if videoCount == 0 {
            self.doneWithVideoFound(videoFound: false)
        }
        else{
            self.doneWithVideoFound(videoFound: true)
        }
    }
    
    func doneWithVideoFound(videoFound:Bool) {
        let resultsDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: ["videoOnPage":videoFound ? 1 : 0, "errorMessage" : NSLocalizedString("No compatible video found.\n\nPlease note that if the video is an embedded video (like Youtube player on another site) this will only work on the main page", comment: "errorMessage")]]
            
        let resultsProvider = NSItemProvider(item: resultsDictionary as NSDictionary, typeIdentifier: String(kUTTypePropertyList))
            
        let resultsItem = NSExtensionItem()
        resultsItem.attachments = [resultsProvider]
            
        // Signal that we're complete, returning our results.
        self.extensionContext!.completeRequest(returningItems: [resultsItem], completionHandler: nil)
        
        // Don't hold on to this after we finished with it.
        self.extensionContext = nil
    }

}
