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

    var body: some Scene {
        WindowGroup {
            //ContentView()
            //    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
            
            //TestChartView()
            //    .environment(\.managedObjectContext, persistenceController.container.viewContext)

            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

            
            
            
            
            //DebugView()
            //    .environment(\.managedObjectContext, persistenceController.container.viewContext)

            
            //FilterView()
            //    .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}
