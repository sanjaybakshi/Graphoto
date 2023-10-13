//
//  TfotoFilter.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/29/23.
//

#if false
import Foundation

class TfotoFilterList : ObservableObject {

    @Published var fList : [TfotoFilter] = []

    static let sYearFilterStr    = "Year"
    static let sMonthFilterStr   = "Month"
    static let sDayFilterStr     = "Day"
    static let sCountryFilterStr = "Country"
    static let sStateFilterStr   = "State"
    static let sCityFilterStr    = "City"

    init()
    {
        fList.append(TfotoFilter(name: TfotoFilterList.sYearFilterStr,    value: []))
        fList.append(TfotoFilter(name: TfotoFilterList.sMonthFilterStr,   value: []))
        fList.append(TfotoFilter(name: TfotoFilterList.sDayFilterStr,     value: []))
        fList.append(TfotoFilter(name: TfotoFilterList.sCountryFilterStr, value: []))
        fList.append(TfotoFilter(name: TfotoFilterList.sStateFilterStr,   value: []))
        fList.append(TfotoFilter(name: TfotoFilterList.sCityFilterStr,    value: []))
    }
}
#endif

