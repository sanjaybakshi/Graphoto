//
//  FilterView.swift
//  grafoto
//
//  Created by Sanjay Bakshi on 8/4/23.
//

import SwiftUI
import Charts


struct FilterView: View {
    
    //@State var editMode: EditMode = .active

    @State private var fFilterOrder : [String] = ["Year", "Month", "Day", "Country", "State", "City", "Device"]

    @State private var selection: String?

    //@EnvironmentObject var phModel23: PhotoModel23


    let items = ["Item 1", "Item 2", "Item 3", "Item 4"]

    
    
    // implement list selection
    // https://sarunw.com/posts/swiftui-list-selection/
    
    @ObservedObject var phModel23 : PhotoModel23

    
    var body: some View {
        //NavigationStack {
        
        VStack {
            
            List(selection: $selection) {
                
                ForEach(fFilterOrder, id: \.self) { f in
                    
                    HStack {
                        Text(f)
                        Spacer()
                        
                        Button {
                            print("do")
                            
                        } label : {
                            Text("All")
                        } .frame(width: 70)
                            .background(Color.green)
                            .cornerRadius(3)
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                        
                    }
                }
                .onMove(perform: move)
                //.contentShape(Rectangle())
                
                //.onTapGesture {
                //    print("selected row")
                //}
                
                .onChange(of: selection) { item in
                    itemSelected()
                    
                }
                
            }
            .background(Color.gray)
            
            
            //.environment(\.editMode, $editMode)
            /* This is a hack to make the button work:
             https://swiftuirecipes.com/blog/swiftui-multiple-buttons-in-list-row
             */
            .buttonStyle(.plain)
            
            
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        fFilterOrder.move(fromOffsets: source, toOffset: destination)
    }
    
    private func itemSelected() {
        print("Item Selected: \(selection ?? "None")")

        if (selection != nil) {
            phModel23.fSelectedFilter = selection!
            
            //phModel23.fPhotoFilterList.selFilterIndexFrom(Text: selection!)
        }
    }
}
