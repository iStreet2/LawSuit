//
//  AddClientProgressView.swift
//  LawSuit
//
//  Created by André Enes Pecci on 22/08/24.
//

import SwiftUI

import SwiftUI

struct AddClientProgressView: View {
    @State private var progress: Double = 0.5

    var body: some View {
        VStack {
            ProgressView(value: progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle())
                .padding()

            Button("Aumentar Progresso") {
                if progress < 1.0 {
                    progress += 0.1
                }
            }
            .padding()

            Button("Reduzir Progresso") {
                if progress > 0.0 {
                    progress -= 0.1
                }
            }
            .padding()
        }
    }
}

//#Preview {
//    ContentView(progress: <#T##Double#>)
//}

