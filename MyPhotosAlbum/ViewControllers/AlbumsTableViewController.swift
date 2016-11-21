//
//  AlbumsTableViewController.swift
//  MyPhotosAlbum
//
//  Created by Macarena on 11/20/16.
//  Copyright © 2016 Celia. All rights reserved.
//

import UIKit

class AlbumsTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var albumsArray : NSArray?
    var selectedAlbum : Album?
    var user : User?
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.sharedInstance.fetchAllAlbumsForUser((user?.id)!, completion: { [unowned self] result in
            dispatch_async(dispatch_get_main_queue(),{
                self.albumsArray = result
                self.tableView.reloadData()
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if albumsArray != nil {
            return (albumsArray?.count)!
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath)
        
        if let album = albumsArray?.objectAtIndex(indexPath.row) as! Album? {
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.text = album.title
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.accessoryType = .DisclosureIndicator
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedAlbum = albumsArray?.objectAtIndex(indexPath.row) as? Album
        performSegueWithIdentifier("PhotosInAlbum", sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! PhotosViewController
        controller.album = selectedAlbum
    }

}
