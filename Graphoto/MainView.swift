//
//  MainView.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/23/23.
//

import SwiftUI

struct MainView: View {
    

    @State var photoModel = PhotoModel23()
    @State var photoDatabaseLoaded = false

    var body: some View {
        
        if (photoDatabaseLoaded == true) {
            
            GraphotoView(photoModel: $photoModel)
            
        } else {
            
            LoadPhotosView(photoModel: $photoModel, photoDatabaseLoaded: $photoDatabaseLoaded)
                    
        }

    }
}
