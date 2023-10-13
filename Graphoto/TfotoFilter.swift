//
//  TfotoFilter.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/29/23.
//

import Foundation

class TfotoFilter : ObservableObject, Identifiable {
    var                    fFilterName   : String = ""
    @Published private var _fFilterValue : [String] = []
    var                    uniqueID      : UUID


    var fFilterValue : String {
        get {
            if (_fFilterValue.count == 0) {
                return "All"
            } else {
                var rString = ""
                for f in _fFilterValue {
                    rString.append(f)                    
                }
                return rString
            }
        }

        set {
            _fFilterValue.removeAll()
            _fFilterValue.append(newValue)
        }
    }

    
    init(name: String, value: [String])
    {
        fFilterName  = name
        _fFilterValue = value
        uniqueID = UUID()
    }

    func filterValueAsArray() -> [String]
    {
        return _fFilterValue
    }
}

