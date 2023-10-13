//
//  DebugView.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/24/23.
//

#if false
import SwiftUI


class TextModel: ObservableObject {
    @Published var content: String = "Initial Value"
    @Published var fNumClicks : String = "0"
}


struct DebugView: View {
    @ObservedObject var model = TextModel()

    var body: some View {
        VStack {
            Text(model.content)
            Button("Update Text") {
                model.content = "Updated Value"
            }
            
            Text(model.fNumClicks)
            Button("Update Count") {
                
                if let c = Int(model.fNumClicks) {
                    let newc = c + 1
                    model.fNumClicks = String(newc)
                }

            }

        }
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}
#endif

