//
//  FilterView2.swift
//  grafoto
//
//  Created by Sanjay Bakshi on 8/4/23.
//

import SwiftUI


struct FilterView2: View {
    
    @Binding var oFilterList : [TfotoFilter]
    @Binding var oSelFilter  : String

    //@State private var selectedItem: String?

    var body: some View {
        
        VStack {
            Text(oSelFilter)
        
            List(selection: $oSelFilter) {
            //List(selection: $selectedItem) {            
                
                ForEach(oFilterList) { f in
                    
                    
                    HStack {
                        Text(f.fFilterName)
                        //Text("Shit")
                        Spacer()
                        
                        Button {
                            print("do")
                            
                        } label : {
                            Text(f.fFilterValue)
                        } .frame(width: 70)
                            .background(Color.green)
                            .cornerRadius(3)
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)

                    }
                      .tag(f.fFilterName)
                      
                }
                .onMove(perform: move)
                //.contentShape(Rectangle())
                
                //.onTapGesture {
                //    print("selected row")
                //}
                
                .onChange(of: oSelFilter) { item in
                //.onChange(of: selectedItem) { item in
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
        oFilterList.move(fromOffsets: source, toOffset: destination)
    }
    
     
    private func itemSelected() {

        
        print("Item Selected: \(oSelFilter ?? "None")")
        //print("Item Selected: \(selectedItem ?? "None")")
     /*
        if (selection != nil) {
            phModel23.fSelectedFilter = selection!
     */
     //phModel23.fPhotoFilterList.selFilterIndexFrom(Text: selection!)
    }
}
