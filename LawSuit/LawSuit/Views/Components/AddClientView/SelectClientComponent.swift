//
//  ClientCheckboxIconComponent.swift
//  LawSuit
//
//  Created by Emily Morimoto on 15/08/24.
//

import SwiftUI

struct SelectClientComponent: View {
    
    //MARK: Variáveis de estado
    @State var searchQuery = ""
    @State var isEditing = false
    @Binding var lawsuitParentAuthorName: String
    @Binding var lawsuitDefendant: String
    @Binding var defendantOrClient: String
    var screen: SizeEnumerator
    
    //MARK: Variáveis ambiente
    @Environment(\.dismiss) var dismiss
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var clients: FetchedResults<Client>
    
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
                    Text(client.name)
                        .onTapGesture {
                            if defendantOrClient == "client" {
                                lawsuitParentAuthorName = client.name
                            } else {
                                lawsuitDefendant = client.name
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
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.secondary, lineWidth: 0.3)
        )
    }
    
    var filteredClients: [Client] {
        if searchQuery.isEmpty {
            return Array(clients)
        } else {
            return clients.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) == true }
        }
    }
}


