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
    @Environment(\.dismiss) var dismiss
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    
    //MARK: Variáveis de estado
    @ObservedObject var client: Client
    @Binding var deleted: Bool
    @State var selectedOption = "Processos"
    @State var createLawsuit = false
    @State var showingGridView = true
    var infos = ["Processos", "Documentos"]

    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var lawsuits: FetchedResults<Lawsuit>
    
    
    init(client: Client, deleted: Binding<Bool>) {
        self.client = client
        self._deleted = deleted
        
        _lawsuits = FetchRequest<Lawsuit>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "authorID == %@ OR defendantID == %@", client.id, client.id)
        )
    }
    
    var body: some View {
        VStack {
            if deleted {
                Text("Selecione um cliente")
                    .foregroundColor(.gray)
            } else {
                VStack(alignment: .leading) {
                    ClientInfoView(client: client, deleted: $deleted, mailManager: MailManager(client: client))
                    Divider()
                    HStack {
                        CustomSegmentedControl(selectedOption: $selectedOption, infos: infos)
                            .padding(5)
                           
                        Spacer()
                        if selectedOption == "Processos" {
                            Button(action: {
                                createLawsuit.toggle()
                            }, label: {
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .foregroundStyle(Color(.gray))
                            })
                            .padding(.trailing)
                            .buttonStyle(PlainButtonStyle())
                        } else {
                            if let openFolder = folderViewModel.getOpenFolder(){
                                DocumentActionButtonsView(folder: openFolder )
                            }
                        }
                    }
                }
                VStack(alignment: .leading) {
                    
                    if selectedOption == "Processos" {
                        NavigationStack {
                            LawsuitListViewHeaderContent(lawsuits: lawsuits)
                        }
                    } else {
                        Button {
                            folderViewModel.closeFolder()
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .buttonStyle(PlainButtonStyle())
                        .font(.title2)
                        .disabled(folderViewModel.getPath().count() == 1)
                        DocumentView()
                            .onAppear {
                                navigationViewModel.selectedClient = client
                                folderViewModel.resetFolderStack() //caminho fica sem nada
                                folderViewModel.openFolder(folder: client.rootFolder) //abre a root folder do cliente que estou selecionado
                                navigationViewModel.dismissLawsuitView.toggle()
                            }
                            .padding()
                    }
                }
            }
        }
        .sheet(isPresented: $createLawsuit, content: {
                AddLawsuitView()
        })
    }
}

