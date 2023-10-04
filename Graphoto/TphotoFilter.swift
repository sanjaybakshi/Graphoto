//
//  TphotoFilter.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/29/23.
//

import Foundation


struct yearChartData: Identifiable {
    var id = UUID()
    var year: String
    var numPhotos: Int
}

struct monthChartData: Identifiable {
    var id = UUID()
    var month: String
    var numPhotos: Int
}

class TphotoFilter {
    
    var fFilterType   : String = ""
    var fFilterSetting: [String] = []
    
    init(fType: String, filterSetting: [String])
    {
        
    }
    
    func filterByYear(yearList: [String], inputList: [TphotoGraphsAsset]) -> [TphotoGraphsAsset]
    {
        // If no countries specified, return the full list.
        //
        if (yearList.count == 0) {
            return inputList
        }
        
        var newPhotoList = [TphotoGraphsAsset]()
        
        for p in inputList {
            if let pDate = p.fAsset.creationDate {
                let pYear = dateUtils().GetYearFromDate(pDate)
                if yearList.contains(pYear) {
                    newPhotoList.append(p)
                }
            }
        }
        return newPhotoList
    }
    
    func organizedByYear(photoList: [TphotoGraphsAsset]) -> [yearChartData]
    {
        var photosPerYear = [String: Int]()
        
        if photoList.count > 0 {
            for i in (0 ..< photoList.count) {
                let asset = photoList[i]
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
        
        var yearsChartData = [yearChartData]()
        let sortedYears = Array(photosPerYear.keys).sorted(by: >)
        
        for (y) in sortedYears {
            yearsChartData.append( yearChartData(year: y, numPhotos: photosPerYear[y]!))
        }
        return yearsChartData
    }
    
    func organizedByMonth(photoList: [TphotoGraphsAsset]) -> [monthChartData]
    {
        var photosPerMonth = [String: Int]()
        
        if photoList.count > 0 {
            for i in (0 ..< photoList.count) {
                let asset = photoList[i]
                if let imgCreationDate = asset.fAsset.creationDate {
                    let monthStr = dateUtils().GetMonthFromDate(imgCreationDate)
                    if let numPhotos = photosPerMonth[monthStr] {
                        photosPerMonth.updateValue(numPhotos+1, forKey: monthStr)
                    } else {
                        photosPerMonth[monthStr] = 1
                    }
                }
            }
        }
        
        var monthsChartData = [monthChartData]()
        
        let monthOrder: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

        let sortedMonths = Array(photosPerMonth.keys).sorted() {
            monthOrder.firstIndex(of: $0)! < monthOrder.firstIndex(of: $1)!
        }

        //var sortedMonths = Array(photosPerMonth.keys).sorted(by: <)
        
        for (m) in sortedMonths {
            monthsChartData.append(monthChartData(month: m, numPhotos: photosPerMonth[m]!))
        }
        
        return monthsChartData
    }

    
    
}
    
class TphotoFilterList : ObservableObject {
    
    var fFilterList : [TphotoFilter] = []
    var fSelectedFilterIndex : Int = 0
    
    let fYearFilterStr      = "Year"
    let fMonthFilterStr     = "Month"
    let fDayFilterStr       = "Day"
    let fCountryFilterStr   = "Country"
    let fStateFilterStr     = "State"
    let fCityFilterStr      = "City"

    init()
    {
        fFilterList.append(TphotoFilter(fType: fYearFilterStr,    filterSetting: []))
        fFilterList.append(TphotoFilter(fType: fMonthFilterStr,   filterSetting: []))
        fFilterList.append(TphotoFilter(fType: fDayFilterStr,     filterSetting: []))
        fFilterList.append(TphotoFilter(fType: fCountryFilterStr, filterSetting: []))
        fFilterList.append(TphotoFilter(fType: fStateFilterStr,   filterSetting: []))
        fFilterList.append(TphotoFilter(fType: fCityFilterStr,    filterSetting: []))
    }

    func selFilterIndexFrom(Text: String)
    {
        if let index = fFilterList.firstIndex(where: { $0.fFilterType == Text }) {
            fSelectedFilterIndex = index
        } else {
            fSelectedFilterIndex = 0
        }
    }
    
    func getChartData(inputList: [TphotoGraphsAsset]) -> [yearChartData]
    {
        // Should apply the filters.
        //
        let barViewData = fFilterList[0].organizedByYear(photoList: inputList)

        return barViewData
    }
 
    func getChartData_month(inputList: [TphotoGraphsAsset]) -> [monthChartData]
    {
        // Should apply the filters.
        //
        let barViewData = fFilterList[0].organizedByMonth(photoList: inputList)

        return barViewData
    }
}
