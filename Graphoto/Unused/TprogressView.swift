//
//  ProgressView.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/29/23.
//
#if false
import SwiftUI

struct TprogressView: View {
    @State private var progress: Double = 0.5

    var body: some View {
        VStack(spacing: 20) {
            ProgressView("Loading", value: progress, total: 1.0)
            
            Button("Increase Progress") {
                if progress < 1.0 {
                    progress += 0.1
                }
            }
        }
        .padding()
    }
}

#Preview {
    ProgressView()
}
#endif

