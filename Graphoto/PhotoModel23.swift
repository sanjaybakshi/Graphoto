//
//  PhotoModel23.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/29/23.
//

import Foundation
import SwiftUI


class PhotoModel23: ObservableObject {
    

    
    
    @Published var fPhotosModel     = TphotoGraphModel()
    @Published var fPhotoFilterList = TphotoFilterList()
    
    @Published var fSelectedFilter : String = "Year"
    
    
    
    init()
    {

    }

    func loadPhotos(progressVariable: Binding<Double>, finishedLoading: Binding<Bool>)
    {
        let group = DispatchGroup()
        group.enter()
        
        // avoid deadlocks by not using .main queue here
        DispatchQueue.global(qos: .utility).async {
            
            self.fPhotosModel.loadCityDatabase(progressUpdateFunc: { p in
                //progressVariable.wrappedValue = Double(p)
            })
            self.fPhotosModel.syncPhotosDatabase(progressUpdateFunc: { p in
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
                self.updateFilterGraphs()
            }
             */
        }

    }
    
    func updateProgressFunc(percentageDone: Float)
    {
        
    }
    /*
    func loadPhotos()
    {
        // In the case when you first startup the app it will ask for permission to access
        // the photo library.  If the request is accepted, this function is called on thread
        // that isn't the main thread.
        //
        // That's why we force main thread for these UI updates.
        //
        DispatchQueue.main.async{

            self.view.addSubview(self.fProgressView)
            self.fProgressView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
            self.fProgressView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
            self.fProgressView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            self.fProgressView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
            self.fProgressView.setup(progressLabel: "Categorizing photos in database...")
        }
        
        let group = DispatchGroup()
        group.enter()
        
        // avoid deadlocks by not using .main queue here
        DispatchQueue.global(qos: .utility).async {
            self.fPhotosModel.loadCityDatabase(progressUpdateFunc: self.updateProgressFunc)
            self.fPhotosModel.syncPhotosDatabase(progressUpdateFunc: self.updateProgressFunc)
            group.leave()
        }
        
        // wait ...
        
        
        group.notify(queue: .main) {
            self.fProgressView.removeFromSuperview()
            
            if (self.fFilterView.getSelectedFilter() == nil) {
                self.fFilterView.selectFilter(filter: self.fYearFilterStr)
                self.updateFilterGraphs()
            }
        }

    }
*/
    
    func noAuthorizationToPhotos()
    {
        // Bring up the screen that allows them to go to settings to specify
        // permission.
        //
        /*
        let alertController = UIAlertController (title: "Photo-Graphs", message: "Photo-Graphs needs access to your photo library to be useful.  It doesn't edit your photo library in any way.  Go to settings and give permission to Photo-Graphs to access your photo library.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
            }
        }
        alertController.addAction(settingsAction)
        
        present(alertController, animated: true, completion: self.cback)
         
         */
    }
/*
    func applyFilters(filter: [String], filterSetting: [[String]?]) -> TphotoGraphAssetList
    {
        let filteredPhotoList = fPhotosModel.GetPhotolist()
        
        for i in (0 ..< filter.count) {
            
            let thisFilterType = filter[i]
            if let thisFilterSetting = filterSetting[i] {
                
                if (thisFilterType == filteredPhotoList
                    filteredPhotoList.FiltertBy(cityList: thisFilterSetting)
                } else if (thisFilterType == fStateFilterStr) {
                    filteredPhotoList.FiltertBy(stateList: thisFilterSetting)
                } else if (thisFilterType == fCountryFilterStr) {
                    filteredPhotoList.FiltertBy(countryList: thisFilterSetting)
                } else if (thisFilterType == fYearFilterStr) {
                    filteredPhotoList.FilterBy(yearList: thisFilterSetting)
                } else if (thisFilterType == fMonthFilterStr) {
                    filteredPhotoList.FilterBy(monthList: thisFilterSetting)
                } else if (thisFilterType == fDayFilterStr) {
                    filteredPhotoList.FilterBy(dayList: thisFilterSetting)
                }
            }
        }
        
        return filteredPhotoList
    }

    
    func getChartData()
    {
        // Apply the filters above the fOrderedFilters.setFilter
        //
        let fOrderedFilters = fPhotoFilterList.fFilterList
        let selFilterIndex  = fPhotoFilterList.fSelectedFilterIndex
        
        var relevantFilters = [String]()
        var relevantFilterSettings = [[String]?]()
        
        for i in (0 ..< selFilterIndex) {
            relevantFilters.append(fOrderedFilters[i].fFilterType)
            relevantFilterSettings.append(fOrderedFilters[i].fFilterSetting)
        }
        
        let filteredPhotoList = applyFilters(filter: relevantFilters, filterSetting: relevantFilterSettings)
        
        var barViewData_labels    = [String]()
        var barViewData_numPhotos = [Int]()
        
        if (fOrderedFilters.filter[selFilterIndex] == fYearFilterStr) {
            let barViewData = filteredPhotoList.organizedByYear()
            barViewData_labels = barViewData.years
            barViewData_numPhotos = barViewData.numPhotos
        } else if (fOrderedFilters.filter[selFilterIndex] == fMonthFilterStr) {
            let barViewData = filteredPhotoList.organizedByMonth()
            barViewData_labels = barViewData.months
            barViewData_numPhotos = barViewData.numPhotos
        } else if (fOrderedFilters.filter[selFilterIndex] == fDayFilterStr) {
            let barViewData = filteredPhotoList.organizedByDay()
            barViewData_labels = barViewData.days
            barViewData_numPhotos = barViewData.numPhotos
        } else if (fOrderedFilters.filter[selFilterIndex] == fCountryFilterStr) {
            let barViewData = filteredPhotoList.organizedByCountry()
            barViewData_labels = barViewData.countries
            barViewData_numPhotos = barViewData.numPhotos
        } else if (fOrderedFilters.filter[selFilterIndex] == fStateFilterStr) {
            let barViewData = filteredPhotoList.organizedByState()
            barViewData_labels = barViewData.states
            barViewData_numPhotos = barViewData.numPhotos
        } else if (fOrderedFilters.filter[selFilterIndex] == fCityFilterStr) {
            let barViewData = filteredPhotoList.organizedByCity()
            barViewData_labels = barViewData.cities
            barViewData_numPhotos = barViewData.numPhotos
        }
        
    }
    */
}
