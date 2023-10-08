//
//  LoadPhotosView.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/29/23.
//

import SwiftUI

struct LoadPhotosView: View {
    
    @State private var progress: Double = 0.0
    
    @EnvironmentObject var phModel23: PhotoModel23
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
        
        self.phModel23.loadPhotos(progressVariable: $progress, finishedLoading: $photoDatabaseLoaded)
    }

}
