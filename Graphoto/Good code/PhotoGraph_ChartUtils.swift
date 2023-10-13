import Foundation


func getChartData(filters: [TfotoFilter], photoList: [TphotoGraphAsset]) -> 
{
    let filteredPhotos = applyFilters(filters: filters, photoList: photoList)

    if (filters.count > 0) {
        let lastFilter = filters[count-1]

        if (lastFilter.filterName == MyStateData.sYearFilterStr) {

            
        }
        

    }

}
