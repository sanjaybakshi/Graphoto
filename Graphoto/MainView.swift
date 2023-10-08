//
//  MainView.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/23/23.
//

import SwiftUI

struct MainView: View {
    

    @EnvironmentObject var phModel23: PhotoModel23

    @State var photoDatabaseLoaded = false

    var body: some View {
        
        if (photoDatabaseLoaded == true) {
            
            GraphotoView()
            
        } else {
            
            LoadPhotosView(photoDatabaseLoaded: $photoDatabaseLoaded)
                    
        }

    }
}
