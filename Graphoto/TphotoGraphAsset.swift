//
//  TphotoGraphsAsset.swift
//
//  Created by Sanjay Bakshi on 6/4/18.
//  Copyright © 2018 Same Eyes Software. All rights reserved.
//

import Photos


class TphotoGraphAsset
{
    var fAsset   : PHAsset = PHAsset()
    var fCountry : String? = nil
    var fState   : String? = nil
    var fCity    : String? = nil
    
    var fYear    : String? {
        var year : String?
        if let photoDate = fAsset.creationDate {
            year = dateUtils().GetYearFromDate(photoDate)
        }
        return year
    }
    var fMonth   : String? {
        var month : String?
        if let photoDate = fAsset.creationDate {
            month = dateUtils().GetMonthFromDate(photoDate)
        }
        return month
    }
    var fDay   : String? {
        var day : String?
        if let photoDate = fAsset.creationDate {
            day = dateUtils().GetDayFromDate(photoDate)
        }
        return day
    }

    static var fNoCountryCode   = "Unspecified"
    static var fNoStateCode     = "Unspecified"
    static var fNoCityCode      = "Unspecified"
}
