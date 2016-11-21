//
//  User.swift
//  MyPhotosAlbum
//
//  Created by Macarena on 11/18/16.
//  Copyright © 2016 Celia. All rights reserved.
//

import Foundation

class User {
    var id : NSInteger
    var name: String
    
    init(id: NSInteger, name: String) {
        self.id = id
        self.name = name
    }
}
