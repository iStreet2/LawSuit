//
//  ClientCheckboxIconComponent.swift
//  LawSuit
//
//  Created by Emily Morimoto on 15/08/24.
//

import SwiftUI

struct ClientCheckboxIconComponent: View {
    
    @Binding var lawsuit: ProcessMock
    @State var clients = ["Carlos Gomes Barbosa", "Micher Autopeças"]
    @State var searchQuery = ""
    @Binding var choosedClient: String
    @State var isEditing = false
    @State var showingDetail = false
    var screen: SizeEnumerator
    @Environment(\.dismiss) var dismiss
    @Binding var defendantOrClient: String
    
    var body: some View {
        VStack{
            HStack{
                SearchBarCheckboxComponent(searchText: $searchQuery)
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark.circle")
                })
            }
            List {
                ForEach(filteredClients, id: \.self) { client in
                    Text(client)
                        .onTapGesture {
                            choosedClient = client
                            if defendantOrClient == "client" {
                                lawsuit.client.name = client
                            } else {
                                lawsuit.defendant = client
                            }
                            dismiss()
                        }
                        .background(isEditing ? Color.blue : Color(.white))
                }
                .padding(2)
            }
        }
        .frame(width: CGFloat(screen.size.width), height: CGFloat(screen.size.height))
        .padding(10)
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
            return clients.filter({ $0.localizedCaseInsensitiveContains(searchQuery)})
        }
    }
}



