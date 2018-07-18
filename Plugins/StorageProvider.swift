//
//  StorageProvider.swift
//  Finstagram
//
//  Created by Ayman Zeine on 7/5/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import PromiseKit

class StorageProvider {
    
    private static let _instance = StorageProvider()
    
    static var Instance: StorageProvider {
        return _instance
    }
    
    //root dir reference
    var storageRef: StorageReference {
        return Storage.storage().reference()
    }
    
    //profileImages dir reference
    var profileImgRef: StorageReference {
        return storageRef.child(Constants.PROFILE_IMAGE_URL)
    }
    
    //User posts dir reference
    var postsRef: StorageReference {
        return storageRef.child(Constants.POSTS)
    }
    
    func saveProfileImage(withID: String, username: String, email: String, img: Data){
        
        let singleRef = profileImgRef.child(withID)
        
        singleRef.putData(img, metadata: nil, completion: {(metadata, error) in
            if error != nil {
                return //error
            }
            
            let path = metadata?.path
            
            //saving user information with image url within asynchronous closure
            self.getDownloadURL(from: path!, completion: {(url, error) in
                DBProvider.Instance.saveUser(withID: withID, username: username, email: email, profileImgURL: (url?.absoluteString)!)
            })
            
        })
    } //save profileImage func
    
    
    //Photo is being posted from Camera VC
    func savePostPhoto(withID: String, img: Data, caption: String?) {
        
        //store photo in firebase storage
        let singleRef = postsRef.child(withID)
        
        //saving image to storage provider
        singleRef.putData(img, metadata: nil, completion: {(metadata, error) in
            if error != nil {
                return
            }
            
            let path = metadata?.path
            
            self.getDownloadURL(from: path!, completion: {(url, error) in
                let photoURL = url?.absoluteString
                
                //store posted photo data in appropriate db reference
                DBProvider.Instance.saveUserPost(photoURL: photoURL!, captionText: caption!)
            })
        })
        print("Storage Completed")
    }
    
    private func getDownloadURL(from path: String, completion: @escaping (URL?, Error?) -> Void) {
        self.storageRef.child(path).downloadURL(completion: completion)
    }
    
} //singleton class
