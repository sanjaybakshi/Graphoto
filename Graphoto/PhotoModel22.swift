//
//  PhotoModel22.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/28/23.
//

import Foundation
import Photos


class PhotoModel22: ObservableObject {
    
    @Published var fTotalNumAssets       : String = "0"
    @Published var fTotalNumPhotos       : String = "0"
    @Published var fTotalNumDevicePhotos : String = "0"
    
    var fPhotoMgr : TcloudPhotosRequestor?
    
    var fAllMediaList :   [PHAsset] = []
    
    init()
    {
        
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    /*
                    let fFetchOptions = PHFetchOptions()
                    
                    fFetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
                    let fFetchResult = PHAsset.fetchAssets(with: fFetchOptions)

                    for i in (0 ..< fFetchResult.count) {
                        let asset = fFetchResult.object(at: i)

                    fPhotoMgr = TcloudPhotosRequestor(targetSize: CGSizeMake(1024, 1024), assetList: fFetchResult)
*/
                    self.buildListOfPhotos()
                }
                break
            default:
                // Handle other cases
                break
            }
        }
    }
    
    func buildListOfPhotos()
    {
        let fFetchOptions = PHFetchOptions()
        
        fFetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        let fFetchResult = PHAsset.fetchAssets(with: fFetchOptions)
        
        self.fTotalNumAssets = String(fFetchResult.count)
        
        for i in (0 ..< fFetchResult.count) {
            let asset = fFetchResult.object(at: i)
            collectDataForAsset(asset: asset)
        }
        
    }
    
    func collectDataForAsset(asset: PHAsset)
    {
        if (asset.mediaType == PHAssetMediaType.image) {
            
            if let c = Int(self.fTotalNumPhotos) {
                
                let newc = c + 1
                self.fTotalNumPhotos = String(newc)

                // Is it on device?
                //
                

            }
        }
    }
    
    func isAssetOnDevice(asset: PHAsset, completion: @escaping (Bool) -> Void) {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = false // Don't fetch from iCloud
        options.isSynchronous = true

        
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 100, height: 100),
                                              contentMode: .aspectFit, options: options) { (image, info) in
            if let info = info, let isDegraded = info[PHImageResultIsDegradedKey] as? Bool, !isDegraded {
                // The asset is on the device
                completion(true)
            } else {
                // The asset is not on the device or the request failed
                completion(false)
            }
        }
    }

}
