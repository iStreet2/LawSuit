//
//  NoInternetView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 23/10/24.
//

import SwiftUI

struct NoInternetView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Image("NoInternet")
            Text("Você está offine!")
                .font(.title)
                .bold()
            Text("Verifique sua conexão e tente novamente.")
                .font(.title3)
                .foregroundStyle(.secondary)
            Button {
                dismiss()
            } label: {
                Text("Ok")
            }
            .buttonStyle(.borderedProminent)
            .tint(.arqBlack)
        }
        .padding()
    }
}

#Preview {
    NoInternetView()
}
