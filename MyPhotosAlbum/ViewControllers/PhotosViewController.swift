//
//  PhotosViewController.swift
//  MyPhotosAlbum
//
//  Created by Macarena on 11/20/16.
//  Copyright © 2016 Celia. All rights reserved.
//

import UIKit

class PhotosViewController: UICollectionViewController {
    
    //MARK: - Properties
    
    var photosArray :  NSArray?
    var album : Album?

    let imageCache = NSCache()
    
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    let itemsPerRow : CGFloat = 4
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.center = view.center;
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        APIManager.sharedInstance.fetchAllPhotosForAlbum((album?.id)!, completion: { [unowned self] result in
            dispatch_async(dispatch_get_main_queue(),{
                self.activityIndicator.stopAnimating()
                self.photosArray = result
                self.collectionView!.reloadData()
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- UICollectionView DataSource
   
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photosArray != nil {
            return (photosArray?.count)!
        }
        return 0;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell",forIndexPath:indexPath)
        
        if let photo = photosArray?.objectAtIndex(indexPath.row) as! Photo? {
            if let cachedImage = imageCache.objectForKey(photo.url) as? UIImage {
                cell.backgroundColor = UIColor(patternImage: cachedImage)
            }
            else if let url = NSURL(string: photo.url) {
                NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error)
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), {
                            if let downloadedImage = UIImage(data: data!) {
                                self.imageCache.setObject(downloadedImage, forKey:url)
                                cell.backgroundColor = UIColor(patternImage: downloadedImage)
                            }
                        })
                    }
                }).resume()
            }
        }
        
        return cell
    }

    // MARK:- UICollectioViewDelegateFlowLayout methods

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

