//
//  FinstaHandler.swift
//  Finstagram
//
//  Created by Ayman Zeine on 7/2/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FinstaHandler {
    
    private static let _instance = FinstaHandler()
    
    static var Instance: FinstaHandler {
        return _instance
    }
    
    var username = ""
    var user_email = ""
    var user_id = ""

    let SIGNIN_SEGUE = "MainTabBarVC"
    let SIGNUP_SEGUE = "MainTabBarVC2"
    
}
