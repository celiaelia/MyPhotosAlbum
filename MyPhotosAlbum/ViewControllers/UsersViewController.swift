//
//  UsersViewController.swift
//  MyPhotosAlbum
//
//  Created by Macarena on 11/18/16.
//  Copyright © 2016 Celia. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var usersArray :  NSArray?
    var selectedUser : User?
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 20.0, right: 20.0)
    let itemsPerRow : CGFloat = 4
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.sharedInstance.fetchAllUsers({ [unowned self] result in
             dispatch_async(dispatch_get_main_queue(),{
                self.usersArray = result
                self.collectionView.reloadData()
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Users"
        navigationItem.backBarButtonItem = backItem
        
        let controller = segue.destinationViewController as! AlbumsTableViewController
        controller.user = selectedUser
    }
}

// MARK:- UICollectionView DataSource

extension UsersViewController : UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if usersArray != nil {
            return (usersArray?.count)!
        }
        return 0;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : UserCell = collectionView.dequeueReusableCellWithReuseIdentifier("UserCell",forIndexPath:indexPath) as! UserCell
        
        if let user = usersArray?.objectAtIndex(indexPath.row) as! User? {
            cell.titleLabel.text = user.name
        }
        
        return cell
    }
}

// MARK:- UICollectionViewDelegate Methods

extension UsersViewController : UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedUser = usersArray?.objectAtIndex(indexPath.row) as? User
        performSegueWithIdentifier("UserAlbums", sender: nil)
    }
}

// MARK:- UICollectioViewDelegateFlowLayout methods

extension UsersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize  {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


