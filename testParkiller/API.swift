//
//  API.swift
//  testParkiller
//
//  Created by Luis Arias on 07/08/16.
//  Copyright © 2016 Luis Arias. All rights reserved.
//

import Foundation
import Accounts
import Social

class API: NSObject {
    
    class func screenShot(view: UIView) -> UIImage {
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func postToTwitter(mediaID: String, message: String) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            (granted, error) in
            
            if granted {    
                let accounts = accountStore.accountsWithAccountType(accountType)
                if accounts.count > 0 {
                    // This will default to the first account if they have more than one
                    
                    let account = accounts.first as! ACAccount
                    let url = "https://api.twitter.com/1.1/statuses/update.json"
                    let requestURL = NSURL(string: url)
                    let parameters = ["status" : message, "display_coordinates": "true", "media_ids": mediaID]
                    
                    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: requestURL, parameters: parameters)
                    request.account = account
                    request.performRequestWithHandler({ (data, response, error) in
                        if (response != nil) {
                            print("Response: \(response)")
                        } else {
                            print("error")
                        }
                    })
                } else {
                    print("We haven't got access")
                }
            }
        }
    }
    
    class func postImage(view: UIView, message: String) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        //Encode image
        let image = API.screenShot(view)
        let imageData = UIImageJPEGRepresentation(image, 0.9)
        let imageEnconded = imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            (granted, error) in
            
            if granted {
                let accounts = accountStore.accountsWithAccountType(accountType)
                if accounts.count > 0 {
                    
                    let account = accounts.first as! ACAccount
                    let url = "https://upload.twitter.com/1.1/media/upload.json"
                    let requestURL = NSURL(string: url)
                    let parameters = ["media" : imageEnconded!]
                    
                    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: requestURL, parameters: parameters)
                    request.account = account
                    request.performRequestWithHandler({ (data, response, error) in
                        if (response != nil) {
                            
                            API.parsingData(data, message: message)
                        } else {
                            print("Error")
                        }
                    })
                } else {
                    print("We haven't got access")
                }
            }
        }
    }
    
    class func parsingData(data: NSData, message: String) {
        
        var mediaStringID: String = "" {
            willSet {
                API.postToTwitter(newValue, message: message)
            }
        }
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            if let mediaId = json["media_id_string"] as? String {
                mediaStringID = mediaId
            } else {
                print("Something's wrong")
            }
        } catch {
            print(error)
        }
    }
    

}