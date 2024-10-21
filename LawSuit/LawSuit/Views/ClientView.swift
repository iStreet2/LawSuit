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
    @EnvironmentObject var dragAndDropViewModel: DragAndDropViewModel
    
    //MARK: Variáveis de estado
    @ObservedObject var client: Client
    @Binding var deleted: Bool
    @State var selectedOption = "Processos"
    @State var lawsuitSelectedOption = "All"
    @State var createLawsuit = false
    @State var showingGridView = true

    
    var infos = ["Processos", "Documentos"]
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var lawsuits: FetchedResults<Lawsuit>
    
    var isFirstFolderOpen: Bool {
        return folderViewModel.getPath().count() == 1
    }
    
    var buttonColor: Color {
        return isFirstFolderOpen ? Color(NSColor.tertiaryLabelColor) : Color(.black)
    }
    
    init(client: Client, deleted: Binding<Bool>) {
        self.client = client
        self._deleted = deleted
        _lawsuits = FetchRequest<Lawsuit>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "authorID == %@ OR defendantID == %@", client.id, client.id)
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if deleted {
                    Text("Selecione um cliente")
                        .foregroundColor(.gray)
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        ClientInfoView(client: client, deleted: $deleted, mailManager: MailManager(client: client))
                        Divider()
                        HStack {
                            CustomSegmentedControl(selectedOption: $selectedOption, infos: infos)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                            
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
                                    DocumentActionButtonsView(folder: openFolder)
                                        .padding(.trailing, 20)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        if selectedOption == "Processos" {
                            LawsuitListViewHeaderContent(lawsuits: lawsuits, lawsuitTypeString: $lawsuitSelectedOption)
                        } else {
                            HStack(spacing: 0) {
                                Button {
                                    folderViewModel.closeFolder()
                                } label: {
                                    Image(systemName: "chevron.left")
                                }
                                .buttonStyle(PlainButtonStyle())
                                .foregroundColor(buttonColor)
                                .font(.title2)
                                .disabled(folderViewModel.getPath().count() == 1)
                                .padding(.horizontal, 20)
                                //Aqui eu preciso de um onDrop, para voltar uma pasta
                                .onDrop(of: ["public.folder", "public.file-url"], isTargeted: nil) { providers in
                                    withAnimation {
                                        if let openFolder = folderViewModel.getOpenFolder() {
                                            if let movingFolder = dragAndDropViewModel.movingFolder {
                                                if let destinationFolder = openFolder.parentFolder {
                                                    dataViewModel.coreDataManager.folderManager.moveFolder(parentFolder: openFolder, movingFolder: movingFolder, destinationFolder: destinationFolder)
                                                    dragAndDropViewModel.movingFolder = nil
                                                    return true
                                                }
                                            } else if let movingFilePDF = dragAndDropViewModel.movingFilePDF {
                                                if let destinationFolder = openFolder.parentFolder {
                                                    dataViewModel.coreDataManager.filePDFManager.moveFilePDF(parentFolder: openFolder, movingFilePDF: movingFilePDF, destinationFolder: destinationFolder)
                                                    dragAndDropViewModel.movingFilePDF = nil
                                                    return true
                                                }
                                            }
                                        }
                                        dragAndDropViewModel.movingFolder = nil
                                        dragAndDropViewModel.movingFilePDF = nil
                                        return false
                                    }
                                }
                                
                                Text((folderViewModel.getPath().count() == 1 ? "" : folderViewModel.getOpenFolder()?.name) ?? "Sem nome")
                                    .font(.title3)
                                    .bold()
                                    .frame(height: 24)
                            }
                            .padding(.bottom, 10)
                            
                            DocumentView()
                                .onAppear {
                                    navigationViewModel.selectedClient = client
                                    //caminho fica sem nada
                                    folderViewModel.resetFolderStack()
                                    //abre a root folder do cliente que estou selecionado
                                    folderViewModel.openFolder(folder: client.rootFolder)
                                }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $createLawsuit, content: {
            AddLawsuitView()
        })
    }
}

