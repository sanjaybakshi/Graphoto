//
//  GraphotoView.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/29/23.
//

import SwiftUI

struct GraphotoView: View {
    
    
    //@ObservedObject var photoModel22 = PhotoModel22()
    
    @EnvironmentObject var phModel23: PhotoModel23

    var body: some View {
        
        GeometryReader { geometry in
            
            HStack {
                
                FilterView(phModel23: phModel23)
                Spacer()
                
                VStack() {
                    
                    /*
                    Text("holy Shit")
                        .frame(width: geometry.size.width * 0.6) // 60% of the parent width
                        .background(Color.blue)  // Just for visualization
                    
                    //Text(photoModel.fNumPhotos)
                    
                    //Text("Number of items: \(photoModel.fDevicesList.count)")
                    
                    
                    Text("Total number of assets: \(photoModel22.fTotalNumAssets)")
                    Text("Total number of photos: \(photoModel22.fTotalNumPhotos)")
                    Text("Total number of photos on device: \(photoModel22.fTotalNumDevicePhotos)")
                    */
                    ChartView(phModel23: phModel23)
                        .frame(width: geometry.size.width * 0.8) // 60% of the parent width

                    
                    //ChartView(photoModel: photoModel)
                    //  .background(Color.gray)
                    
                    
                    
                    Spacer()
                }
            }
        }
    }
}

