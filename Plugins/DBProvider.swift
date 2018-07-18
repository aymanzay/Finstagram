//
//  DBProvider.swift
//  Finstagram
//
//  Created by Ayman Zeine on 7/1/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider {
    
    private static let _instance = DBProvider()
    
    static var Instance: DBProvider {
        return _instance
    }
    
    //reference to database
    var dbRef: DatabaseReference {
        return Database.database().reference()
    }
    
    //user dir reference
    var userRef: DatabaseReference {
        return dbRef.child(Constants.USERS)
    }
    
    //user posts dir reference
    var userPostsRef: DatabaseReference {
        return userRef.child(Constants.POSTS)
    }
    
    func saveUser(withID: String, username: String, email: String, profileImgURL: String) {
        let data: Dictionary<String, Any> = [Constants.USERNAME:username, Constants.EMAIL:email, Constants.PROFILE_IMAGE_URL:profileImgURL]
        
        //will create entry if not found
        userRef.child(withID).child(Constants.DATA).setValue(data)
    }
    
    //Photo being posted from cameraVC via StorageProvider
    func saveUserPost(photoURL: String, captionText: String?) {
        let data: Dictionary<String, Any> = [Constants.PHOTO_URL:photoURL,
            Constants.PHOTO_CAPTION:captionText!]
        
        let newPostID = userPostsRef.childByAutoId().key
        let newPostRef = userPostsRef.child(newPostID)
        
        newPostRef.setValue(data, withCompletionBlock: { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            print("Database Completed")
            ProgressHUD.showSuccess("Success")
        })
    }

}
