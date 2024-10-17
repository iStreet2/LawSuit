//
//  ClientRowNotSelectView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 08/10/24.
//

import SwiftUI

struct ClientRowNotSelectView: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 40, height: 40)
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 97, height: 13)
            Spacer()
        }
        .foregroundStyle(.secondary.opacity(0.2))
        .padding( 5)
    }
}

#Preview {
    ClientRowNotSelectView()
}
