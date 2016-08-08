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
        //Save it to the camera roll
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
//        return image
    }
    
    class func postToTwitter(mediaID: String) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            (granted, error) in
            
            if granted {    
                let accounts = accountStore.accountsWithAccountType(accountType)
                if accounts.count > 0 {
                    // This will default to the first account if they have more than one
                    
//                    let image = API.screenShot(view)
                    
                    let account = accounts.first as! ACAccount
                    let url = "https://api.twitter.com/1.1/statuses/update.json"
                    let requestURL = NSURL(string: url)
                    let parameters = ["status" : "Trying my app :P", "display_coordinates": "true", "media_ids": mediaID]
                    
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
    
    class func postImage(view: UIView) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
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
                            
                            API.parsingData(data)
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
    
    class func parsingData(data: NSData) -> String {
        
        var mediaStringID: String = "" {
            willSet {
                API.postToTwitter(newValue)
            }
        }
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            print("JSON: \n \(json)")
            if let mediaId = json["media_id_string"] as? String {
                mediaStringID = mediaId
            } else {
                print("Algo fallo en el parsing")
                return ""
            }
        } catch {
            print(error)
        }
        
        return ""
    }
    

}