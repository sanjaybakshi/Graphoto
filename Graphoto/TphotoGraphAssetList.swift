//
//  TphotoGraphAssetList.swift
//
//  Created by Sanjay Bakshi on 6/4/18.
//  Copyright © 2018 Same Eyes Software. All rights reserved.
//

import Photos

class TphotoGraphAssetList : NSCopying
{
    var fPhotoList = [TphotoGraphAsset]()



    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = TphotoGraphAssetList()
        var copyPhotoList = [TphotoGraphAsset]()
        
        for f in fPhotoList {
            copyPhotoList.append(f)
        }
        copy.fPhotoList = copyPhotoList
        return copy
    }






    
    func FiltertBy(cityList: [String])
    {
        var lookingForUnspecified = false
        if (cityList.contains( TphotoGraphAsset.fNoCityCode )) {
            lookingForUnspecified = true
        }

        var newPhotoList = [TphotoGraphAsset]()
        
        for p in fPhotoList {
            if let pCity = p.fCity {
                if cityList.contains(pCity) {
                    newPhotoList.append(p)
                }
            } else if lookingForUnspecified == true {
                newPhotoList.append(p)
            }
        }
        fPhotoList = newPhotoList
    }
    
    func FiltertBy(stateList: [String])
    {
        // If no countries specified, return the full list.
        //
        if (stateList.count == 0) {
            return
        }

        var lookingForUnspecified = false
        if (stateList.contains( TphotoGraphAsset.fNoStateCode )) {
            lookingForUnspecified = true
        }

        var newPhotoList = [TphotoGraphAsset]()
        
        for p in fPhotoList {
            if let pState = p.fState {
                if stateList.contains(pState) {
                    newPhotoList.append(p)
                }
            } else if lookingForUnspecified == true {
                newPhotoList.append(p)
            }
        }
        fPhotoList = newPhotoList
    }
    
    func FiltertBy(countryList: [String])
    {
        var lookingForUnspecified = false
        if (countryList.contains( TphotoGraphAsset.fNoCountryCode )) {
            lookingForUnspecified = true
        }

        var newPhotoList = [TphotoGraphAsset]()
        
        for p in fPhotoList {
            if let pCountry = p.fCountry {
                if countryList.contains(pCountry) {
                    newPhotoList.append(p)
                }
            } else if lookingForUnspecified == true {
                newPhotoList.append(p)
            }
        }
        fPhotoList = newPhotoList
    }

    func FilterBy(yearList: [String]) 
    {
        // If no countries specified, return the full list.
        //
        if (yearList.count == 0) {
            return
        }

        var newPhotoList = [TphotoGraphAsset]()
        
        for p in fPhotoList {
            if let pDate = p.fAsset.creationDate {
                let pYear = dateUtils().GetYearFromDate(pDate)
                if yearList.contains(pYear) {
                    newPhotoList.append(p)
                }
            }
        }
        fPhotoList = newPhotoList
    }
    
    func FilterBy(monthList: [String])
    {
        // If no countries specified, return the full list.
        //
        if (monthList.count == 0) {
            return
        }

        let timer1 = ParkBenchTimer()
        var newPhotoList = [TphotoGraphAsset]()

        let dUtils = dateUtils()

        // Convert monthList to Int's to speed up compares.
        //
        var monthListInt = [Int]()
        for m in monthList {
            let monthInt = dUtils.monthLongStringToInt(month: m)
            monthListInt.append(monthInt)
        }
        
        for p in fPhotoList {
            if let pDate = p.fAsset.creationDate {
                let pMonthInt = dUtils.GetMonthIntFromDate(pDate)
                if monthListInt.contains(pMonthInt) {
                    newPhotoList.append(p)
                }
            }
        }
        fPhotoList = newPhotoList
        // print("The timer1 took took \(timer1.stop()) seconds.")
    }

    func FilterBy(dayList: [String])
    {
        // If no countries specified, return the full list.
        //
        if (dayList.count == 0) {
            return
        }

        let timer1 = ParkBenchTimer()

        var newPhotoList = [TphotoGraphAsset]()
        
        //print("in filterby, filtering: \(fPhotoList.count)")
        for p in fPhotoList {
            if let pDate = p.fAsset.creationDate {
                let pDay = dateUtils().GetDayFromDate(pDate)
                if dayList.contains(pDay) {
                    newPhotoList.append(p)
                }
            }
        }
        fPhotoList = newPhotoList
        //print("The timer1 took took \(timer1.stop()) seconds.")
    }

    func organizedByYear() -> (years: [String], numPhotos: [Int])
    {
        var photosPerYear = [String: Int]()
        
        if fPhotoList.count > 0 {
            for i in (0 ..< fPhotoList.count) {
                let asset = fPhotoList[i]
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
    
    func organizedByMonth() -> (months: [String], numPhotos: [Int])
    {
        var photosPerMonth = [Int: Int]()
        
        if fPhotoList.count > 0 {
            for i in (0 ..< fPhotoList.count) {
                let asset = fPhotoList[i]
                if let imgCreationDate = asset.fAsset.creationDate {
                    let month = dateUtils().GetMonthIntFromDate(imgCreationDate)
                    if let numPhotos = photosPerMonth[month] {
                        photosPerMonth.updateValue(numPhotos+1, forKey: month)
                    } else {
                        photosPerMonth[month] = 1
                    }
                }
            }
        }
        
        var monthsArray     = [String]()
        var numPhotosArray  = [Int]()
        
        let sortedMonths = Array(photosPerMonth.keys).sorted(by: <)
        
        for (m) in sortedMonths {
            let monthAsString = dateUtils().monthNumToLongString(month: m)
            
            monthsArray.append(monthAsString)
            numPhotosArray.append(photosPerMonth[m]!)
        }
        
        return(monthsArray, numPhotosArray)
    }

    func organizedByDay() -> (days: [String], numPhotos: [Int])
    {
        var photosPerDay = [Int: Int]()
        
        if fPhotoList.count > 0 {
            for i in (0 ..< fPhotoList.count) {
                let asset = fPhotoList[i]
                if let imgCreationDate = asset.fAsset.creationDate {
                    let day = dateUtils().GetDayIntFromDate(imgCreationDate)
                    if let numPhotos = photosPerDay[day] {
                        photosPerDay.updateValue(numPhotos+1, forKey: day)
                    } else {
                        photosPerDay[day] = 1
                    }
                }
            }
        }
        
        var daysArray      = [String]()
        var numPhotosArray = [Int]()
        
        let sortedDays = Array(photosPerDay.keys).sorted(by: <)
        
        for (d) in sortedDays {
            let daysAsString = String(d)
            
            daysArray.append(daysAsString)
            numPhotosArray.append(photosPerDay[d]!)
        }
        
        return(daysArray, numPhotosArray)
    }
    
    func organizedByCountry() -> (countries: [String], numPhotos: [Int])
    {
        var photosPerCountry = [String: Int]()
        
        if fPhotoList.count > 0 {
            for i in (0 ..< fPhotoList.count) {
                let asset = fPhotoList[i]
                
                if let country = asset.fCountry {
                    if let numPhotos = photosPerCountry[country] {
                        photosPerCountry.updateValue(numPhotos+1, forKey: country)
                    } else {
                        photosPerCountry[country] = 1
                    }
                } else {
                    let country = TphotoGraphAsset.fNoCountryCode
                    if let numPhotos = photosPerCountry[country] {
                        photosPerCountry.updateValue(numPhotos+1, forKey: country)
                    } else {
                        photosPerCountry[country] = 1
                    }
                }
            }
        }
        
        var countriesArray  = [String]()
        var numPhotosArray  = [Int]()
        let byValue = {
            (elem1:(key: String, val: Int), elem2:(key: String, val: Int))->Bool in
            if elem1.val > elem2.val {
                return true
            } else {
                return false
            }
        }
        let sortedCountries = photosPerCountry.sorted(by: byValue)
        
        for (m) in sortedCountries {
            countriesArray.append(m.key)
            numPhotosArray.append(m.value)
        }
        return(countriesArray, numPhotosArray)
    }

    func organizedByState() -> (states: [String], numPhotos: [Int])
    {
        var photosPerState = [String: Int]()
        
        if fPhotoList.count > 0 {
            for i in (0 ..< fPhotoList.count) {
                let asset = fPhotoList[i]
                
                if let state = asset.fState {
                    if let numPhotos = photosPerState[state] {
                        photosPerState.updateValue(numPhotos+1, forKey: state)
                    } else {
                        photosPerState[state] = 1
                    }
                } else {
                    let state = TphotoGraphAsset.fNoStateCode
                    if let numPhotos = photosPerState[state] {
                        photosPerState.updateValue(numPhotos+1, forKey: state)
                    } else {
                        photosPerState[state] = 1
                    }
                }
            }
        }
        
        var statesArray  = [String]()
        var numPhotosArray  = [Int]()
        let byValue = {
            (elem1:(key: String, val: Int), elem2:(key: String, val: Int))->Bool in
            if elem1.val > elem2.val {
                return true
            } else {
                return false
            }
        }
        let sortedStates = photosPerState.sorted(by: byValue)
        
        for (m) in sortedStates {
            statesArray.append(m.key)
            numPhotosArray.append(m.value)
        }
        return(statesArray, numPhotosArray)
    }

    func organizedByCity() -> (cities: [String], numPhotos: [Int])
    {
        let timer1 = ParkBenchTimer()
        
        var photosPerCity = [String: Int]()
        
        if fPhotoList.count > 0 {
            for i in (0 ..< fPhotoList.count) {
                let asset = fPhotoList[i]
                
                if let city = asset.fCity {
                    if let numPhotos = photosPerCity[city] {
                        photosPerCity.updateValue(numPhotos+1, forKey: city)
                    } else {
                        photosPerCity[city] = 1
                    }
                } else {
                    let city = TphotoGraphAsset.fNoCityCode
                    if let numPhotos = photosPerCity[city] {
                        photosPerCity.updateValue(numPhotos+1, forKey: city)
                    } else {
                        photosPerCity[city] = 1
                    }
                }
            }
        }
        //print("The timer1 took took \(timer1.stop()) seconds.")
        
        let timer2 = ParkBenchTimer()
        
        var citiesArray  = [String]()
        var numPhotosArray  = [Int]()
        let byValue = {
            (elem1:(key: String, val: Int), elem2:(key: String, val: Int))->Bool in
            if elem1.val > elem2.val {
                return true
            } else {
                return false
            }
        }
        let sortedCities = photosPerCity.sorted(by: byValue)
        
        for (m) in sortedCities {
            citiesArray.append(m.key)
            numPhotosArray.append(m.value)
        }
        //print("The timer2 took took \(timer2.stop()) seconds.")
        
        return(citiesArray, numPhotosArray)
    }

}
