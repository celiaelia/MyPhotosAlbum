//
//  Photo.swift
//  MyPhotosAlbum
//
//  Created by Macarena on 11/20/16.
//  Copyright © 2016 Celia. All rights reserved.
//

import Foundation

class Photo {
    var id : NSInteger
    var url: String
    
    init(id: NSInteger, url: String) {
        self.id = id
        self.url = url
    }
}
