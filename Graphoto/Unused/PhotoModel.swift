//
//  PhotoModel.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/23/23.
//
#if false
import Foundation

import Photos
import SwiftUI

struct photoDataPoint : Identifiable {
    var id = UUID().uuidString
    var fAsset:     PHAsset
    var fLensInfo:  String?
}

struct devicePoint : Identifiable {
    var id = UUID().uuidString
    var deviceName : String
    var deviceCount : Int
}



class PhotoModel: ObservableObject {
    @Published var fPhotoInfo:   [photoDataPoint] = []

    @Published var fAssets_onDevice:   [PHAsset] = []

    @Published var fFotoList:   [photoDataPoint] = []

    @Published var fNumPhotos : String = "0"

    @Published var fNumClicks : String = "0"
    
    // Dictionary of devices with a count.
    //
    @Published var fDevicesList = [String: Int]()

    @Published var fDevicesListHC : [devicePoint] = []
    
    @Published var fDevicesListHC_dict = [String: Int]()
    
    init()
    {
        fDevicesListHC.append(devicePoint(deviceName: "iphone7",  deviceCount:  100))
        fDevicesListHC.append(devicePoint(deviceName: "iphone8",  deviceCount:  10))
        fDevicesListHC.append(devicePoint(deviceName: "iphone9",  deviceCount:  101))
        fDevicesListHC.append(devicePoint(deviceName: "iphone10", deviceCount:  45))

        
        self.fDevicesListHC_dict["iphone7"]  = 100
        self.fDevicesListHC_dict["iphone8"]  = 10
        self.fDevicesListHC_dict["iphone9"]  = 101
        self.fDevicesListHC_dict["iphone10"] = 45

        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                
                let fFetchOptions = PHFetchOptions()
                fFetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
                var fFetchResult = PHAsset.fetchAssets(with: fFetchOptions)
                
                for i in (0 ..< fFetchResult.count) {
                    let asset = fFetchResult.object(at: i)
                    
                    self.isAssetOnDevice(asset: asset, completion: { isOnDevice in
                        if (isOnDevice) {
                            
                            if let c = Int(self.fNumPhotos) {
                                let newc = c + 1
                                
                                DispatchQueue.main.async {
                                self.fNumPhotos = String(newc)
                                    self.fAssets_onDevice.append(asset)
                                    
                                    
                                    if (asset.mediaType == PHAssetMediaType.image) {
                                        
                                        if let imgLocation = asset.location {
                                            
                                            if (asset.location != nil) {
                                                
                                                //print("\(i) is a location: \(asset.location!.coordinate.latitude)")
                                            }
                                        }

                                    }

                                }

                                
                                /*
                                self.getLensInfo(for: asset, completion: { lensInfo in
                                    
                                    if (lensInfo != nil) {
                                        print(lensInfo!)
                                    }
                                    
                                })
                                 */
                                
                                //let progress = Float(i) / Float(self.fFetchResult.count-1)
                                /*
                                 DispatchQueue.main.async {
                                 
                                 if (progressUpdateFunc != nil) {
                                 progressUpdateFunc!(progress)
                                 }
                                 }
                                 */
                            }
                        }
                    })
                }
                /*
                 
                 fFetchResult.enumerateObjects { (asset, _, _) in
                 
                 self.isAssetOnDevice(asset: asset, completion: { isOnDevice in
                 if (isOnDevice) {
                 
                 if let c = Int(self.fNumPhotos) {
                 let newc = c + 1
                 
                 
                 DispatchQueue.main.async {
                 self.fNumPhotos = String(newc)
                 //self.fAssets_onDevice.append(asset)
                 }
                 
                 
                 self.getLensInfo(for: asset, completion: { lensInfo in
                 //let fto = photoDataPoint(fAsset: asset, fLensInfo: lensInfo)
                 
                 
                 
                 //self.fFotoList.append(fto)
                 
                 var lensInfo_notNil : String = ""
                 
                 if (lensInfo == nil) {
                 lensInfo_notNil = "Unspecified"
                 } else {
                 lensInfo_notNil = lensInfo!
                 }
                 
                 
                 if let numPhotosD = self.fDevicesList[lensInfo_notNil] {
                 self.fDevicesList.updateValue(numPhotosD+1, forKey: lensInfo_notNil)
                 } else {
                 self.fDevicesList[lensInfo_notNil] = 1
                 }
                 /*
                  if let numPhotos = self.fDevicesListHC_dict["iphone10"] {
                  
                  self.fDevicesListHC_dict.updateValue(numPhotos+1, forKey: "iphone10")
                  //print(self.fDevicesListHC_dict)
                  }
                  */
                 })
                 
                 }
                 
                 }
                 })
                 
                 
                 */
            
                
                

                break
            default:
                // Handle other cases
                break
            }
        }
    }
    
    
    func getLensInfo(for asset: PHAsset, completion: @escaping (String?) -> Void) {
        let imageManager = PHImageManager.default()
        
        imageManager.requestImageDataAndOrientation(for: asset, options: nil) { (data, _, _, _) in
            if let data = data, let source = CGImageSourceCreateWithData(data as CFData, nil) {
                if let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any] {
                    if let exifData = properties[kCGImagePropertyExifDictionary as String] as? [String: Any] {
                        // Access specific camera information from the `exifData` dictionary
                        
                        
                        print(exifData)
                        completion("wow")
                        /*
                         if let cameraModel = exifData[kCGImagePropertyExifModel as String] as? String {
                         
                         
                         print("Camera Model: \(cameraModel)")
                         }
                         */
                    }
                }
            }
            completion(nil)
        }

        /*
        imageManager.requestImageDataAndOrientation(for: asset, options: nil) { (data, _, _, _) in
            guard let data = data,
                  let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
                  let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any],
                  let exifDict = imageProperties["{Exif}"] as? [String: Any],
                  let lensModel = exifDict["LensModel"] as? String else {
                completion(nil)
                return
            }
            completion(lensModel)
        }
         */
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
    
    /*
    func syncPhotosDatabase(progressUpdateFunc: ((Float) -> ())? = nil)
        //
        // Description:
        //      Use PhotoKit to get all of the media in Photos.
        //
    {

        self.fAllPhotos.fPhotoList.removeAll()
            
        let fFetchOptions = PHFetchOptions()
        fFetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
            
        self.fFetchResult = PHAsset.fetchAssets(with: fFetchOptions)

        for i in (0 ..< self.fFetchResult.count) {
            let asset = self.fFetchResult.object(at: i)
            
            if let thisPhoto = self.photoFromAsset(asset: asset) {
                self.fAllPhotos.fPhotoList.append(thisPhoto)
            }
            
            let progress = Float(i) / Float(self.fFetchResult.count-1)
                
            DispatchQueue.main.async {

                if (progressUpdateFunc != nil) {
                    progressUpdateFunc!(progress)
                }
            }
        }
    }
    */
    
    func organizedByYear() -> (years: [String], numPhotos: [Int])
    {
        var photosPerYear = [String: Int]()
        
        if fFotoList.count > 0 {
            for i in (0 ..< fFotoList.count) {
                let asset = fFotoList[i]
                if let imgCreationDate = asset.fAsset.creationDate {
                    let yearStr = dateUtils().GetYearFromDate(imgCreationDate)
                    if let numPhotos = photosPerYear[yearStr] {
                        photosPerYear.updateValue(numPhotos+1, forKey: yearStr)
                    } else {
                        photosPerYear[yearStr] = 1
                    }
                }
            }
        }
        
        var yearsArray      = [String]()
        var numPhotosArray  = [Int]()
        
        let sortedYears = Array(photosPerYear.keys).sorted(by: >)
        
        for (y) in sortedYears {
            yearsArray.append(y)
            numPhotosArray.append(photosPerYear[y]!)
        }
        
        return(yearsArray, numPhotosArray)
    }
    
}
#endif

