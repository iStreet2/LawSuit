//
//  FolderGridView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//

import SwiftUI

struct FolderView: View {
    
    //MARK: Variáveis
    @ObservedObject var parentFolder: Folder
	
	@State var didTryToDeleteFile: Bool = false
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var dragAndDropViewModel: DragAndDropViewModel
    
    @State var geometry: GeometryProxy?
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest var folders: FetchedResults<Folder>
    
    init(parentFolder: Folder) {
        self.parentFolder = parentFolder
        
        _folders = FetchRequest<Folder>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Folder.createdAt, ascending: true)]
            ,predicate: NSPredicate(format: "parentFolder == %@", parentFolder)
        )
    }
    
    var body: some View {
        ForEach(Array(folders.enumerated()), id: \.offset) { index, folder in
            FolderIconView(folder: folder, parentFolder: parentFolder)
                .frame(maxWidth: .infinity,minHeight: 20, alignment: folderViewModel.showingGridView ? .center : .leading)
                .background(folderViewModel.showingGridView ? Color.clear : Color(index % 2 == 0 ? .gray : .white).opacity(0.1))
                .onTapGesture(count: 2) {
                    folderViewModel.openFolder(folder: folder)
                }
                .onDrop(of: ["public.folder", "public.file-url"], isTargeted: nil) { providers in
                    withAnimation {
                        if let movingFolder = dragAndDropViewModel.movingFolder {
                            if movingFolder.id == folder.id {
                                dragAndDropViewModel.movingFolder = nil
                                return false
                            }
                            dragAndDropViewModel.handleDrop(providers: providers, parentFolder: parentFolder, destinationFolder: folder, context: context, dataViewModel: dataViewModel)
                            return true
                        } else if dragAndDropViewModel.movingFilePDF != nil {
                            dragAndDropViewModel.handleDrop(providers: providers, parentFolder: parentFolder, destinationFolder: folder, context: context, dataViewModel: dataViewModel)
                            dragAndDropViewModel.movingFilePDF = nil
                            return true
                        }
                        dragAndDropViewModel.movingFolder = nil
                        dragAndDropViewModel.movingFilePDF = nil
                        return false
                    }
                }
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            for selectedFolder in folders {
                                selectedFolder.isSelected = (selectedFolder == folder)
                            }
                        }
                )
                .contextMenu {
                    Button(action: {
                        folderViewModel.openFolder(folder: folder)
                    }) {
                        Text("Abrir Pasta")
                        Image(systemName: "folder")
                    }
                    Button(action: {
                        folder.isEditing = true
                    }) {
                        Text("Renomear")
                        Image(systemName: "pencil")
                    }
//                    Button(action: {
//                        withAnimation(.easeIn) {
//                            dataViewModel.coreDataManager.folderManager.deleteFolder(parentFolder: parentFolder, folder: folder)
//                        }
//                    }) {
//                        Text("Excluir")
//                        Image(systemName: "trash")
//                    }
						 Button(action: {
							 didTryToDeleteFile = true
						 }) {
							 Text("Excluir")
							 Image(systemName: "trash")
						 }
                    Button {
                        withAnimation {
                            if let destinationFolder = parentFolder.parentFolder {
                                dataViewModel.coreDataManager.folderManager.moveFolder(parentFolder: parentFolder, movingFolder: folder, destinationFolder: destinationFolder)
                            }
                        }
                    } label: {
                        Text("Mover para pasta anterior")
                        Image(systemName: "arrowshape.turn.up.left")
                    }
                    .disabled(parentFolder.parentFolder == nil)
                }
//                .transition(.scale)
					 .alert(isPresented: $didTryToDeleteFile) {
						 Alert(title: Text("Tem certeza que deseja excluir a pasta \(folder.name) e todos os arquivos dentro?"),
								 message: Text("Você excluirá \(dataViewModel.coreDataManager.folderManager.getFolderItemsCount(folder: folder).0) arquivo(s) e \(dataViewModel.coreDataManager.folderManager.getFolderItemsCount(folder: folder).1) pasta(s)."),
								 primaryButton: .destructive(Text("Sim, excluir"), action: {
							 didTryToDeleteFile = false
							 dataViewModel.coreDataManager.folderManager.deleteFolder(parentFolder: parentFolder, folder: folder)
						 }),
								 secondaryButton: .cancel(Text("Cancelar"), action: {
							 didTryToDeleteFile = false
						 }))
					 }
        }
    }
}

