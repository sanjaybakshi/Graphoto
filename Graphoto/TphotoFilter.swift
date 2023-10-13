//
//  TphotoFilter.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/29/23.
//

import Foundation


struct phChartData: Identifiable {
    var id = UUID()
    var xVal: String
    var numPhotos: Int
}

class TphotoFilter {
    
    var fFilterType   : String = ""
    var fFilterSetting: [String] = []
    
    init(fType: String, filterSetting: [String])
    {
        
    }
    
    func filterByYear(yearList: [String], inputList: [TphotoGraphAsset]) -> [TphotoGraphAsset]
    {
        // If no countries specified, return the full list.
        //
        if (yearList.count == 0) {
            return inputList
        }
        
        var newPhotoList = [TphotoGraphAsset]()
        
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
    
    func organizedByYear(photoList: [TphotoGraphAsset]) -> [phChartData]
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
        
        var yearsChartData = [phChartData]()
        let sortedYears = Array(photosPerYear.keys).sorted(by: >)
        
        for (y) in sortedYears {
            yearsChartData.append( phChartData(xVal: y, numPhotos: photosPerYear[y]!))
        }
        return yearsChartData
    }
    
    func organizedByMonth(photoList: [TphotoGraphAsset]) -> [phChartData]
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
        
        var monthsChartData = [phChartData]()
        
        let monthOrder: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

        let sortedMonths = Array(photosPerMonth.keys).sorted() {
            monthOrder.firstIndex(of: $0)! < monthOrder.firstIndex(of: $1)!
        }

        //var sortedMonths = Array(photosPerMonth.keys).sorted(by: <)
        
        for (m) in sortedMonths {
            monthsChartData.append(phChartData(xVal: m, numPhotos: photosPerMonth[m]!))
        }
        
        return monthsChartData
    }

    
    
}
    
class TphotoFilterList : ObservableObject {
    
    var fFilterList : [TphotoFilter] = []
    //@Published var fSelectedFilterIndex : Int = 0
    

    /*
    var fSelectedFilter : String {
        return fFilterList[fSelectedFilterIndex].fFilterType
    }
*/
    
    let fYearFilterStr      = "Year"
    let fMonthFilterStr     = "Month"
    let fDayFilterStr       = "Day"
    let fCountryFilterStr   = "Country"
    let fStateFilterStr     = "State"
    let fCityFilterStr      = "City"

    //@Published var fSelectedFilter : String = "Year"

    init()
    {
        fFilterList.append(TphotoFilter(fType: fYearFilterStr,    filterSetting: []))
        fFilterList.append(TphotoFilter(fType: fMonthFilterStr,   filterSetting: []))
        fFilterList.append(TphotoFilter(fType: fDayFilterStr,     filterSetting: []))
        fFilterList.append(TphotoFilter(fType: fCountryFilterStr, filterSetting: []))
        fFilterList.append(TphotoFilter(fType: fStateFilterStr,   filterSetting: []))
        fFilterList.append(TphotoFilter(fType: fCityFilterStr,    filterSetting: []))
    }

    /*
    func selFilterIndexFrom(Text: String)
    {
        if let index = fFilterList.firstIndex(where: { $0.fFilterType == Text }) {
            fSelectedFilterIndex = index
        } else {
            fSelectedFilterIndex = 0
        }
    }
    */
    
    /*
    func getChartDataForSelectedFilter(inputList: [TphotoGraphsAsset]) -> [phChartData]?
    {
        
        switch fSelectedFilter {
        case fMonthFilterStr :
            return getChartData_month(inputList: inputList)
        case fYearFilterStr :
            return getChartData_year(inputList: inputList)
        default:
            return getChartData_year(inputList: inputList)
        }
    }
    */

    func getChartData(chartType: String, inputList: [TphotoGraphAsset]) -> [phChartData]
    {
        switch chartType {
        case fMonthFilterStr :
            return getChartData_month(inputList: inputList)
        case fYearFilterStr :
            return getChartData_year(inputList: inputList)

        default:
            return getChartData_year(inputList: inputList)
        }

    }
                 
                 
    func getChartData_year(inputList: [TphotoGraphAsset]) -> [phChartData]
    {
        // Should apply the filters.
        //
        let barViewData = fFilterList[0].organizedByYear(photoList: inputList)

        return barViewData
    }
 
    func getChartData_month(inputList: [TphotoGraphAsset]) -> [phChartData]
    {
        // Should apply the filters.
        //
        let barViewData = fFilterList[0].organizedByMonth(photoList: inputList)

        return barViewData
    }
    

}
