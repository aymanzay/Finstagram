//
//  Post.swift
//  Finstagram
//
//  Created by Ayman Zeine on 7/19/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import Foundation

class Post {
    
    var caption: String
    var photoUrl: String
    
    init(captionText:String, photoUrlString: String) {
        caption = captionText
        photoUrl = photoUrlString
    }
}
