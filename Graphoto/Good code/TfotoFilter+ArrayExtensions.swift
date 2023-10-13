


extension Array where Element == TfotoFilter {



    func applyFilters(photoList: TphotoGraphAssetList) -> TphotoGraphAssetList
    {

        var filteredPhotoList : TphotoGraphAssetList = photoList.copy() as! TphotoGraphAssetList
        
        for instance in self {
            let filterValue = instance.filterValueAsArray()
            
            if (filterValue.count == 0) {
                continue
            }
            
            if (instance.fFilterName == MyStateData.sCityFilterStr) {
                filteredPhotoList.FiltertBy(cityList: filterValue)
            } else if (instance.fFilterName == MyStateData.sStateFilterStr) {
                filteredPhotoList.FiltertBy(stateList: filterValue)
            } else if (instance.fFilterName == MyStateData.sCountryFilterStr) {
                filteredPhotoList.FiltertBy(countryList: filterValue)
            } else if (instance.fFilterName == MyStateData.sYearFilterStr) {
                filteredPhotoList.FilterBy(yearList: filterValue)
            } else if (instance.fFilterName == MyStateData.sMonthFilterStr) {
                filteredPhotoList.FilterBy(monthList: filterValue)
            } else if (instance.fFilterName == MyStateData.sDayFilterStr) {
                filteredPhotoList.FilterBy(dayList: filterValue)
            }
            
        }
        return filteredPhotoList
    }


    func trimFilters(lastFilter: String) -> [TfotoFilter]
    {
        var trimmedFilters : [TfotoFilter] = [TfotoFilter]()
    
        var found = false
    
        for i in 0 ..< self.count where !found {
            if (self[i].fFilterName != lastFilter) {
                trimmedFilters.append(self[i])
            } else {
                trimmedFilters.append(self[i])
                found = true
            }
        }

        return trimmedFilters
    }
}

