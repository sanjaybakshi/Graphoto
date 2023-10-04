//
//  LoadPhotosView.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/29/23.
//

import SwiftUI

struct LoadPhotosView: View {
    
    @State private var progress: Double = 0.0
    
    @Binding var photoModel          : PhotoModel23
    @Binding var photoDatabaseLoaded : Bool

    var body: some View {
        
        VStack {
            if (!photoDatabaseLoaded) {
                ProgressView("Categorizing photos...", value: progress, total: 1)
            }
        } .onAppear(perform: startLoadPhotos)
    }
    
    func startLoadPhotos() {
        photoDatabaseLoaded = false
        progress = 0
        
        self.photoModel.loadPhotos(progressVariable: $progress, finishedLoading: $photoDatabaseLoaded)
    }

}
