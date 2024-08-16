//
//  ClientCheckboxIconComponent.swift
//  LawSuit
//
//  Created by Emily Morimoto on 15/08/24.
//

import SwiftUI

struct ClientCheckboxIconComponent: View {
    
    @State var clients = ["Abigail da Silva", "Abigail Lima", "Andre Miguel"]
    @State var searchQuery = ""
    
    var body: some View {
        VStack{
            SearchBarCheckboxComponent(searchText: $searchQuery)
            List {
                ForEach(clients, id: \.self) { client in
                    Text(client)
                }
                
                .padding(2)
                
            }
        }

        .background(.white)
        .cornerRadius(10) /// make the background rounded
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 10)
                .stroke(.secondary, lineWidth: 0.3)
        )
//        .padding(100)
    }
}

#Preview {
    ClientCheckboxIconComponent()
}
