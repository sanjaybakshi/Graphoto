//
//  PhotosModel.swift
//  PhotoGraph2
//
//  Created by Sanjay Bakshi on 6/4/18.
//  Copyright © 2018 Same Eyes Software. All rights reserved.
//

import Photos
import SwiftUI


class TphotoGraphModel : NSObject, ObservableObject
{
    private var fAllPhotos   = TphotoGraphAssetList()
    private var fFetchResult : PHFetchResult<PHAsset>!

    private var fAllCities   : TCityDatabase!
    

    override init()
    {
        super.init()
    }
    
    

    func canAccessPhotos() -> Bool
    {
        let photos = PHPhotoLibrary.authorizationStatus()
        
        if photos == .authorized {
            return true
        }
        
        return false
    }
    
    func requestAccessToPhotos(authorizationAcceptedFunc: (() -> ())?, authorizationDeclinedFunc: (() -> ())?) {
        
        PHPhotoLibrary.requestAuthorization({status in
            if status == .authorized{
                authorizationAcceptedFunc?()
            } else {
                authorizationDeclinedFunc?()
            }
        })
    }

    
    
    
    // This has to be called first!
    // We separate loadCityDatabase and syncPhotosDatabase as they
    // are time consuming and we want to update a progress bar.
    //
    
    func loadCityDatabase(progressUpdateFunc: ((Float) -> ())? = nil)
    {
        self.fAllCities = TCityDatabase(cacheFile: "Split4x3", read: true, progressUpdateFunc: progressUpdateFunc)
    }
    
    func syncPhotosDatabase(progressUpdateFunc: ((Float) -> ())? = nil)
        //
        // Description:
        //      Use PhotoKit to get all of the media in Photos.
        //
    {
        let timer1 = ParkBenchTimer()
            
        self.fAllPhotos.fPhotoList.removeAll()
            
        let fFetchOptions = PHFetchOptions()
        fFetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        fFetchOptions.fetchLimit=10000
        
        //let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
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
        // print("The syncPhotosDatabase timer took took \(timer1.stop()) seconds.")

    }
    
    func photoFromAsset(asset: PHAsset) -> TphotoGraphAsset?
    {
        var thisPhoto : TphotoGraphAsset? = nil
        
        if (asset.mediaType == PHAssetMediaType.image) {
            
            thisPhoto = TphotoGraphAsset()
            thisPhoto!.fAsset = asset
            
            var foundCountry : String? = nil
            var foundState   : String? = nil
            var foundCity    : String? = nil
            
            (foundCountry, foundState, foundCity) = GetLocation(photo: asset)
            
            thisPhoto!.fCountry = foundCountry
            thisPhoto!.fState   = foundState
            thisPhoto!.fCity    = foundCity
        }
        
        return thisPhoto
    }

    func GetLocation(photo: PHAsset) -> (retCountry: String?, retState: String?, retCity: String?)
        //
        // Description:
        //      Returns the city that this photo was taken in (if that info. is available).
        //
    {
        var nearestCity    : String?
        var nearestCountry : String?
        var nearestState   : String?
        
        if let imgLocation = photo.location {
            
            let locInfo = fAllCities.findLocation(latitude: imgLocation.coordinate.latitude,
                                                  longitude: imgLocation.coordinate.longitude)
            
            nearestCity    = locInfo.city
            nearestState   = locInfo.state
            nearestCountry = locInfo.country
            
        }
        return (nearestCountry, nearestState, nearestCity)
    }

    
    /*
    func GetPhotolistCopy() -> TphotoGraphAssetList
    {
        return fAllPhotos.copy() as! TphotoGraphAssetList
    }
*/


    func GetPhotolist() -> TphotoGraphAssetList
    {
        return fAllPhotos
    }




    func loadPhotoDatabase(progressVariable: Binding<Double>, finishedLoading: Binding<Bool>)
    {
        let group = DispatchGroup()
        group.enter()
        
        // avoid deadlocks by not using .main queue here
        DispatchQueue.global(qos: .utility).async {
            
            self.loadCityDatabase(progressUpdateFunc: { p in
                //progressVariable.wrappedValue = Double(p)
            })
            self.syncPhotosDatabase(progressUpdateFunc: { p in
                progressVariable.wrappedValue = Double(p)
                
                if (p >= 1.0) {
                    
                    finishedLoading.wrappedValue = true
                }
            })
            group.leave()
        }
        
        // wait ...
        
        
        group.notify(queue: .main) {

            /*
            if (self.fFilterView.getSelectedFilter() == nil) {
                self.fFilterView.selectFilter(filter: self.fYearFilterStr)
                self.updateFilterGraph()
            }
             */
        }
    }
    
}
