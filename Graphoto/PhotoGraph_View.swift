//
//  PhotoGraph_View.swift
//
//  Created by Sanjay Bakshi on 9/29/23.
//

import SwiftUI

struct PhotoGraph_View: View {
    
    
    @EnvironmentObject var myStateData : MyStateData

    var body: some View {
        
        GeometryReader { geometry in
            
            HStack {
                
                VStack() {
                    FilterView2(oFilterList: $myStateData.fFilterList,
                                oSelFilter: $myStateData.fSelectedFilter)
                    Spacer()
                }
                VStack() {

                    //ChartView(phModel23: phModel23)
                    //    .frame(width: geometry.size.width * 0.8) // 60% of the parent width

                    PhotoGraph_ChartView()
                    
                      .frame(width: geometry.size.width * 0.8) // 60% of the parent width
                    
                    
                    Spacer()
                }
            }
        }
    }
}

