
import SwiftUI

class MyStateData : ObservableObject {

    static let sYearFilterStr    = "Year"
    static let sMonthFilterStr   = "Month"
    static let sDayFilterStr     = "Day"
    static let sCountryFilterStr = "Country"
    static let sStateFilterStr   = "State"
    static let sCityFilterStr    = "City"
    
    @Published var fFilterList     : [TfotoFilter] = []
    @Published var fSelectedFilter : String = MyStateData.sYearFilterStr

    @Published var fPhotoGraph_Database : TphotoGraphModel = TphotoGraphModel()
    
    //@Published var fChartData : [TchartDatas] = [TchartDatas(label: "Monday", value:100), TchartDatas(label: "Friday", value: 200)]

    
    
    var fChartData : [TchartDatas]  {
        
        return getChartData()
        
        //return [TchartDatas(label: "Monday", value:100), TchartDatas(label: "Friday", value: 200)]

    }

    init()
    {
        fFilterList.append(TfotoFilter(name: MyStateData.sYearFilterStr,    value: []))
        fFilterList.append(TfotoFilter(name: MyStateData.sMonthFilterStr,   value: []))
        fFilterList.append(TfotoFilter(name: MyStateData.sDayFilterStr,     value: []))
        fFilterList.append(TfotoFilter(name: MyStateData.sCountryFilterStr, value: []))
        fFilterList.append(TfotoFilter(name: MyStateData.sStateFilterStr,   value: []))
        //fFilterList.append(TfotoFilter(name: MyStateData.sCityFilterStr,    value: ["Regina"]))
        fFilterList.append(TfotoFilter(name: MyStateData.sCityFilterStr,    value: []))
        
    }
    
    func getChartData() -> [TchartDatas]
    {
        // Apply the filters above the filterToChart
        //
        
        let trimmedFilters = fFilterList.trimFilters(lastFilter: fSelectedFilter)
        
        let filteredPhotoList = trimmedFilters.applyFilters(photoList: fPhotoGraph_Database.GetPhotolist())
        
        
        var rawChartData : ([String],[Int]) = ([String](),[Int]())
        
        if (fSelectedFilter == MyStateData.sYearFilterStr) {
            rawChartData = filteredPhotoList.organizedByYear()
        } else if (fSelectedFilter == MyStateData.sMonthFilterStr) {
            rawChartData = filteredPhotoList.organizedByMonth()
        } else if (fSelectedFilter == MyStateData.sDayFilterStr) {
            rawChartData = filteredPhotoList.organizedByDay()
        } else if (fSelectedFilter == MyStateData.sCountryFilterStr) {
            rawChartData = filteredPhotoList.organizedByCountry()
        } else if (fSelectedFilter == MyStateData.sStateFilterStr) {
            rawChartData = filteredPhotoList.organizedByState()
        } else if (fSelectedFilter == MyStateData.sCityFilterStr) {
            rawChartData = filteredPhotoList.organizedByCity()
        }

        var retInfo : [TchartDatas] = [TchartDatas]()

        for i in (0 ..< rawChartData.0.count) {
            let cd = TchartDatas(label: rawChartData.0[i], value: rawChartData.1[i])
            retInfo.append(cd)
        }
        
        return retInfo
    }

}
