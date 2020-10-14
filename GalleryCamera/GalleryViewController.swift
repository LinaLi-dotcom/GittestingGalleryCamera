//
//  GalleryViewController.swift
//  GalleryCamera
//
//  Created by Lina Li on 2020-10-13.
//

import UIKit
import Photos

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
    
    @IBOutlet weak var galleryCollectionview: UICollectionView!
    @IBOutlet weak var selectedImageview: UIImageView!
    
    var photoAsset: PHFetchResult<PHAsset>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
       
    }
    
    func requestAuthorizationHandler(_ status: PHAuthorizationStatus)
    {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
        {
            let fetchOptions: PHFetchOptions = PHFetchOptions ()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            photoAsset = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
            
            DispatchQueue.main.async {
                self.galleryCollectionview.reloadData()
            }
        }
    else {
//    Error NO Access
    }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let pha = photoAsset
        {
            return pha.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photocell", for: indexPath) as! GalleryCollectionViewCell
        
        let imgAsset: PHAsset = photoAsset! [indexPath.item]
        let imageOptions = PHImageRequestOptions()
        imageOptions.isSynchronous = true
        
        let newSize = CGSize(width: (self.view.frame.width/2), height: (self.view.frame.width/2))
        
        PHImageManager.default().requestImage(for: imgAsset, targetSize: newSize, contentMode: PHImageContentMode.aspectFill, options: imageOptions, resultHandler: {(result, info) -> Void in
            cell.galleryCellImage.image = result
        })
            return cell
                            
        }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photocell", for: indexPath) as! GalleryCollectionViewCell
        
        let imgAsset: PHAsset = photoAsset! [indexPath.item]
        let imageOptions = PHImageRequestOptions()
        imageOptions.isSynchronous = true
        
        let newSize = CGSize(width: (self.view.frame.width/2), height: (self.view.frame.width/2))
        
        PHImageManager.default().requestImage(for: imgAsset, targetSize: newSize, contentMode: PHImageContentMode.aspectFill, options: imageOptions, resultHandler: {(result, info) -> Void in
            self.selectedImageview.image = result
        })
    }
}
