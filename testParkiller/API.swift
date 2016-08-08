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
    
    class func postToTwitter() {
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
                    let parameters = ["status" : "Trying my app :P"]
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

}