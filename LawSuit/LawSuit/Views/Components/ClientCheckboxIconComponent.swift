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
                ForEach(filteredClients, id: \.self) { client in
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
    }
    
    var filteredClients : [String] {
        if searchQuery.isEmpty {
            return clients
        } else {
            return clients.filter({ $0.contains(searchQuery)})
        }
    }
        



}



#Preview {
    ClientCheckboxIconComponent()
}
