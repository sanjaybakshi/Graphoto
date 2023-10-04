//
//  TCity.swift
//
//  Created by Sanjay Bakshi on 9/2/17.
//  Copyright © 2017 Theo and Milo Bakshi. All rights reserved.
//

import Foundation
//import UIKit

public class TCity
//
// Description:
//      This holds the information for a single city.
//
{
    public var fLatitude:       Double = 0.0
    public var fLongitude:      Double = 0.0
    public var fCountry:        String = ""
    public var fCity:           String = ""
    public var fState:          String = ""
    
    public func squaredDistance(to otherPoint: TCity) -> Double {
        let x = self.fLongitude - otherPoint.fLongitude
        let y = self.fLatitude - otherPoint.fLatitude
        return Double(x*x + y*y)
    }
}

public class TCityDatabase
//
// Description:
//      This holds a database of cities and provides functions to search
//      for closest city given a latitude and longitude.
//
{
    var fCityTree : TCityNode!
    
    public func findClosestCity(latitude: Double, longitude: Double)  -> TCity?
    {
        let tempCity = TCity()
        tempCity.fLatitude = latitude
        tempCity.fLongitude = longitude
        
        let retCity = fCityTree.findClosestCityTo(thisCity: tempCity)
        
        if (retCity == nil) {
            print("got a nil city")
        }
        return retCity
    }
    
    public func findCity(latitude: Double, longitude: Double) -> String?
    {
        var retCity : String? = nil
        
        let city = findClosestCity(latitude: latitude, longitude: longitude)
        
        if (city != nil) {
            retCity = city?.fCity
        }
        return retCity
    }
    
    public func findCountry(latitude: Double, longitude: Double) -> String?
    {
        var retCountryName : String? = nil
        
        let city = findClosestCity(latitude: latitude, longitude: longitude)
        
        if (city != nil) {
            retCountryName = city?.fCountry
        }
        return retCountryName
    }
    
    public func findState(latitude: Double, longitude: Double) -> String?
    {
        var retState : String? = nil
        
        let city = findClosestCity(latitude: latitude, longitude: longitude)
        
        if (city != nil) {
            retState = city?.fState
        }
        return retState
    }
    
    public func findLocation(latitude: Double, longitude: Double) -> (country: String?, state: String?, city: String?)
    {
        var retCountry : String? = nil
        var retState   : String? = nil
        var retCity    : String? = nil
        
        let city = findClosestCity(latitude: latitude, longitude: longitude)
        
        if (city != nil) {
            retState   = city?.fState
            retCountry = city?.fCountry
            retCity    = city?.fCity
        }
        return (retCountry, retState, retCity)
    }
    
    /*
    public convenience init()
    {
        self.init(cacheFile: "Split16x2", read: true)
    }
    */
    public init(cacheFile: String, read: Bool = true, progressUpdateFunc: ((Float) -> ())? = nil)
    {
        if (read == true) {
            let timer_loadTime = ParkBenchTimer()
        
            fCityTree = TCityNode.read(fileName: cacheFile, progressUpdateFunc: progressUpdateFunc)
        
            print("The load for \(cacheFile) took \(timer_loadTime.stop()) seconds.")
        } else {
            // Build a new cache file.
            //
            // Note:
            //   The resulting file is called SplitCities.txt and is stored in the documented directory
            //   ~/Library/Developer/CoreSimulator/Devices/1FC28870-4C0B-46F0-89FA-E838AA5751EC/data/Containers/Data/Application/609D3F64-4A41-4A8B-981E-DD0E1FC6FE09/Documents
            //   You must copy it by hand to the CityUtils directory.
            //

            fCityTree = TCityNode()
            let bakedTree = fCityTree.bakeCacheFile(fileName: cacheFile)
            fCityTree = bakedTree
            
            
        }
    }
    
    public func cityBounds() -> CGRect
    {
        let minX = fCityTree.latMin
        let maxX = fCityTree.latMax
        let minY = fCityTree.longMin
        let maxY = fCityTree.longMax
        
        return CGRect(x: minX, y: minY, width: maxX-minX, height: maxY-minY)
    }
    /*
    public func drawIntoView(v: UIView)
    {
    }
     */
}




