//
//  Album.swift
//  MyPhotosAlbum
//
//  Created by Macarena on 11/20/16.
//  Copyright © 2016 Celia. All rights reserved.
//

import Foundation

class Album {
    var id : NSInteger
    var title: String
    
    init(id: NSInteger, title: String) {
        self.id = id
        self.title = title
    }
}
