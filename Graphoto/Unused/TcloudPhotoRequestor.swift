//
//  TcloudPhotoRequestor.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/28/23.
//
#if false

import Foundation
import Photos
import AppKit

class TcloudPhotosRequestor
{
    var         _reqID :        PHImageRequestID?
    var         imgRes =        CGSize()
    var         fCacheImgMgr =  PHCachingImageManager()
    var         _assetList:     [PHAsset]
    
    var         fImageStr       = "Image"
    var         fAssetIndexStr  = "AssetIndex"
    var         fAssetViewStr   = "AssetView"
    var         fProgressAmt    = "Progress"
    
    
    // You can call pullRequestForImage to get an image from Photos
    //
    // Messages will be posted as the image becomes available:
    //      ImageFinishedLoading
    //      ImageThumbnail
    //      ImageDownloading
    //      ImageErroredLoading
    //
    // The message will include a data dictionary that has:
    //      ["image:" UIImage, "assetIndex": Int, "assetView:" Any]
    //
    // That is, the image will be the photo, the assetIndex will be the index in assetList for the photo you requested,
    // and the assetView will be a pointer to a view you pass in (that will typically display the image).
    //
    // an unpack method is available for your convenience.
    //
    
    var photoRequestor_imgFinished = Notification.Name("PhotoRequestorNotification_ImageFinishedLoading")
    var photoRequestor_imgThumb    = Notification.Name("PhotoRequestorNotification_ImageThumbnail")
    var photoRequestor_imgDownload = Notification.Name("PhotoRequestorNotification_ImageDownloading")
    var photoRequestor_imgError    = Notification.Name("PhotoRequestorNotification_ImageErroredLoading")
    
    
    
    init (targetSize: CGSize, assetList: [PHAsset])
    {
        imgRes = targetSize
        _assetList = assetList
        
        fCacheImgMgr.stopCachingImagesForAllAssets()
        
        DispatchQueue.global(qos: .background).async {
            self.fCacheImgMgr.startCachingImages(for: self._assetList, targetSize: self.imgRes, contentMode: .aspectFit, options: nil)
        }
    }
    
    deinit {
        fCacheImgMgr.stopCachingImagesForAllAssets()
    }
    
    
    func packMessageData(assetIndex: Int, assetView: Any, photo: NSImage?, progressAmt: Float? = nil) -> [String: Any]
    {
        var dataDict: [String: Any] = [fAssetIndexStr: assetIndex, fAssetViewStr: assetView]
        
        if (photo != nil) {
            dataDict[fImageStr] = photo
        }
        if (progressAmt != nil) {
            dataDict[fProgressAmt] = progressAmt
        }
        
        return dataDict
    }

    func upackMessageData(messageObj: Any?) -> (assetIndex: Int?, assetView: Any?, photo: NSImage?, progressAmt: Float?)
    {
        var retAssetIndex : Int?
        var retAssetView  : Any?
        var retPhoto      : NSImage?
        var retProgress   : Float?

        if let myDict = messageObj as? [String: Any] {
            if let myImg = myDict[fImageStr] as? NSImage {
                retPhoto = myImg
            }
            
            if let myIndex = myDict[fAssetIndexStr] as? Int {
                retAssetIndex = myIndex
            }
            
            if let assetView = myDict[fAssetViewStr] {
                retAssetView = assetView
            }
            
            if let progressAmt = myDict[fProgressAmt] as? Float {
                retProgress = progressAmt
            }
        }
        
        return(retAssetIndex, retAssetView, retPhoto, retProgress)
    }
        

    
    
    func pullRequestForImage(assetIndex: Int, assetView: Any)
    {
        let asset = _assetList[assetIndex]
        
        if (asset.mediaType != PHAssetMediaType.image) {
            return
        }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        //options.deliveryMode = .fastFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        
        options.progressHandler = { progress, _, _, _ in
            // Handler might not be called on the main queue, so re-dispatch for UI work.
            DispatchQueue.main.async {
                // self.progressView.progress = Float(progress)
                self.sendImageDownloading(progress: Float(progress), assetIndex: assetIndex, assetView: assetView)
            }
        }
        
        
        fCacheImgMgr.requestImage(for: asset, targetSize: imgRes, contentMode: .aspectFit, options: options, resultHandler: { image, info in
            // Hide the progress view now the request has completed.
            //self.progressView.isHidden = true
            
            // If successful, show the image view and display the image.
            guard let image = image else {
                DispatchQueue.main.async {

                    self.sendImageErroredLoading(assetIndex: assetIndex, assetView: assetView)
                }
                return
            }
            
            if (info != nil) {
                var degraded = info![PHImageResultIsDegradedKey] as! Bool
                if (degraded) {
                    //print("degraded")
                }
            }
            
            self.sendImageFinishedLoadingNotice(img: image, assetIndex: assetIndex, assetView: assetView)
        })
    }
    
    
    
    func cancelRequestForImage()
    {
        if _reqID != nil {
            fCacheImgMgr.cancelImageRequest(_reqID!)
        }
    }
    
    func sendImageFinishedLoadingNotice(img: NSImage, assetIndex: Int, assetView: Any)
    {
        let dataDict = packMessageData(assetIndex: assetIndex, assetView: assetView, photo: img)
        NotificationCenter.default.post(name: photoRequestor_imgFinished, object: dataDict)
    }
    
    func sendImageThumbnail(img: NSImage, assetIndex: Int, assetView: Any)
    {
        let dataDict = packMessageData(assetIndex: assetIndex, assetView: assetView, photo: img)
        NotificationCenter.default.post(name: photoRequestor_imgThumb, object: dataDict)
    }
    
    func sendImageDownloading(progress: Float, assetIndex: Int, assetView: Any)
    {
        let dataDict = packMessageData(assetIndex: assetIndex, assetView: assetView, photo: nil, progressAmt: progress)
        NotificationCenter.default.post(name: photoRequestor_imgDownload, object: dataDict)
    }
    func sendImageErroredLoading(assetIndex: Int, assetView: Any)
    {
        let dataDict = packMessageData(assetIndex: assetIndex, assetView: assetView, photo: nil)
        NotificationCenter.default.post(name: photoRequestor_imgError, object: dataDict)
    }
    
    
    
    
}

#endif

