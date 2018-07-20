//
//  User.swift
//  Finstagram
//
//  Created by Ayman Zeine on 7/19/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import Foundation

class User {
    
    var username: String
    var email: String
    var profilePhotoURL: String
    
    init(usernameString: String, userEmail: String, profPicURL: String) {
        username = usernameString
        email = userEmail
        profilePhotoURL = profPicURL
    }
}
