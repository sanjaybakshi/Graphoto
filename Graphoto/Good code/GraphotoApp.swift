//
//  GraphotoApp.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/23/23.
//

import SwiftUI

@main
struct GraphotoApp: App {
    let persistenceController = PersistenceController.shared


    var myStateData = MyStateData()

    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            //    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
            
            //TestChartView()
            //    .environment(\.managedObjectContext, persistenceController.container.viewContext)

            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                //.environmentObject(PhotoModel23())
                .environmentObject(myStateData)
            
            
            
            
            
            //DebugView()
            //    .environment(\.managedObjectContext, persistenceController.container.viewContext)

            
            //FilterView()
            //    .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}
