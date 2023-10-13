//
//  TchartData.swift
//
//  Created by Sanjay Bakshi on 10/10/23.
//

import SwiftUI


struct TchartDatas: Identifiable {
    var id = UUID()
    var fLabel: String
    var fValue: Int
    
    init(label: String, value: Int)
    {
        fLabel = label
        fValue = value        
    }

}
