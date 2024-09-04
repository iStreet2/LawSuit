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
    
    //MARK: Variáveis de estado
    @ObservedObject var client: Client
    @Binding var deleted: Bool
    @State var selectedOption = "Processos"
    @State var createLawsuit = false
    var infos = ["Processos", "Documentos"]
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var lawsuits: FetchedResults<Lawsuit>
    
    
    init(client: Client, deleted: Binding<Bool>) {
        self.client = client
        self._deleted = deleted
        
        _lawsuits =  FetchRequest<Lawsuit>(
            sortDescriptors: []
            ,predicate: NSPredicate(format: "parentAuthor == %@", client)
        )
    }
    
    var body: some View {
        VStack {
            if deleted {
                Text("Selecione um cliente")
                    .foregroundColor(.gray)
            } else {
                VStack(alignment: .leading) {
                    ClientInfoView(client: client, deleted: $deleted)
                    Divider()
                    HStack {
                        SegmentedControlComponent(selectedOption: $selectedOption, infos: infos)
                            .padding(5)
                            .frame(width: 190, alignment: .leading)
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
                        }else{
                            Button(action: {
                                
                            }, label: {
                                Image(systemName: "plus")
                                    .opacity(0)
                            })
                            .padding(.trailing)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                VStack {
                    if selectedOption == "Processos" {
                        NavigationStack {
                            LawsuitListViewHeaderContent(lawsuits: lawsuits)
                        }
                    } else {
                        DocumentGridView()
                            .onAppear {
                                folderViewModel.openFolder(folder: client.rootFolder)
                            }
                            .padding()
                    }
                }
            }
        }
//        .toolbar {
//            ToolbarItem(placement: .destructiveAction) {
//                Button(action: {
//                    coreDataViewModel.deleteAllData()
//                }, label: {
//                    Image(systemName: "trash")
//                })
//            }
//        }
        .sheet(isPresented: $createLawsuit, content: {
            AddLawsuitView()
        })
    }
}
