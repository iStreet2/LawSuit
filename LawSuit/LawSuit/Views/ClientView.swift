//
//  DocumentView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import SwiftUI
import CoreData

struct ClientView: View {
    
    //MARK: Variáveis de ambiente
    @EnvironmentObject var folderViewModel: FolderViewModel
    
    //MARK: Variáveis de estado
    @ObservedObject var client: Client
    @Binding var deleted: Bool
    @State var selectedOption = "Processos"
    var infos = ["Processos", "Documentos"]
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    
    
    var body: some View {
        VStack {
            if deleted {
                Text("Selecione um cliente")
                    .foregroundColor(.gray)
            } else {
                VStack(alignment: .leading) {
                    ClientInfoView(client: client, deleted: $deleted)
                    Divider()
                    //Aqui ter um picker de processos e de documentos :D
                    SegmentedControlComponent(selectedOption: $selectedOption, infos: infos)
                        .padding(5)
                        .padding(.trailing, 400)
                    //                    .frame(width: 60)
                    Divider()
                }
                VStack {
                    if selectedOption == "Processos" {
                        Text("View da Micher")
                        Spacer()
                    } else {
                        DocumentGridView()
                            .padding()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button(action: {
                    coreDataViewModel.deleteAllData()
                }, label: {
                    Image(systemName: "trash")
                })
            }
        }
    }
}

