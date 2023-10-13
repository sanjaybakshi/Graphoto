//
//  MainView.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/23/23.
//

import SwiftUI

struct MainView: View {
    

    //@EnvironmentObject var phModel23: PhotoModel23

    //@Binding var oPhotoGraph_Database : TphotosModel

    @EnvironmentObject var myStateData : MyStateData

        
    @State var photoDatabaseLoaded = false

    var body: some View {
        
        if (photoDatabaseLoaded == true) {
            
            //GraphotoView()

            PhotoGraph_View()
            
            
        } else {
            
            LoadPhotosView(oPhotoGraph_Database: $myStateData.fPhotoGraph_Database, photoDatabaseLoaded: $photoDatabaseLoaded)
                    
        }

    }
}
