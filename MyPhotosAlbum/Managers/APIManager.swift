//
//  APIManager.swift
//  MyPhotosAlbum
//
//  Created by Macarena on 11/18/16.
//  Copyright © 2016 Celia. All rights reserved.
//

import Foundation
import ReactiveJSON
import Result
import ReactiveCocoa

class APIManager {
    //MARK: - Shared Instance
    
    static let sharedInstance = APIManager()
    
    //MARK: - Init
    
    private init() {}
    
    //MARK: - Properties
    
    struct MyJSONService: Singleton, ServiceHost {
        private(set) static var shared = Instance()
        typealias Instance = MyJSONService
        
        static var scheme: String { return "http" }
        static var host: String { return "jsonplaceholder.typicode.com" }
        static var path: String? { return nil }
    }
    
    
    //MARK: - API Methods
    
    func fetchAllUsers(completion: (result: [User]) -> Void) {
        MyJSONService.request(endpoint: "users")
            .startWithResult { (result: Result<[[String:AnyObject]], NetworkError>) in
                let usersArray = NSMutableArray()
                
                
                if result.error == nil {
                    for dictionary in result.value! {
                        if let name = dictionary["name"], id = dictionary["id"]?.integerValue {
                            let user = User(id:id, name: name as! String)
                            usersArray.addObject(user)
                        }
                    }
                }
                completion(result: usersArray as NSArray as! [User])
        }
    }
    
    func fetchAllAlbumsForUser(userId: NSInteger, completion: (result: NSArray) -> Void) {
        MyJSONService.request(endpoint: "albums", parameters: ["userId": userId])
            .startWithResult { (result: Result<[[String:AnyObject]], NetworkError>) in
                let albumsArray = NSMutableArray()
                
                for dictionary in result.value! {
                    if let title = dictionary["title"], id = dictionary["id"]?.integerValue {
                        let album = Album(id:id, title: title as! String)
                        albumsArray.addObject(album)
                    }
                }
                completion(result: albumsArray)
        }
    }
    
    func fetchAllPhotosForAlbum(albumId: NSInteger, completion: (result: NSArray) -> Void) {
        MyJSONService.request(endpoint: "photos", parameters: ["albumId": albumId])
            .startWithResult { (result: Result<[[String:AnyObject]], NetworkError>) in
                let photosArray = NSMutableArray()
                
                for dictionary in result.value! {
                    if let url = dictionary["thumbnailUrl"], id = dictionary["id"]?.integerValue {
                        let album = Photo(id:id, url: url as! String)
                        photosArray.addObject(album)
                    }
                }
                completion(result: photosArray)
        }
    }
}

