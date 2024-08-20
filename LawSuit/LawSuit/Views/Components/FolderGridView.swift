//
//  FolderGridView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//

import SwiftUI

struct FolderGridView: View {
    
    //MARK: Variáveis
    @ObservedObject var parentFolder: Folder
    var geometry: GeometryProxy
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var dragAndDropViewModel: DragAndDropViewModel
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest var folders: FetchedResults<Folder>
    
    init(parentFolder: Folder, geometry: GeometryProxy) {
        self.parentFolder = parentFolder
        self.geometry = geometry
        
        _folders = FetchRequest<Folder>(
            sortDescriptors: []
            ,predicate: NSPredicate(format: "parentFolder == %@", parentFolder)
        )
    }

    var body: some View {
        ForEach(folders, id: \.self) { folder in
            FolderIconView(folder: folder, parentFolder: parentFolder)
                .onTapGesture(count: 2) {
                    folderViewModel.openFolder(folder: folder)
                }
                .padding(.leading)
                .offset(x: dragAndDropViewModel.folderOffsets[folder.id!]?.width ?? 0, y: dragAndDropViewModel.folderOffsets[folder.id!]?.height ?? 0)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            dragAndDropViewModel.onDragChangedFolder(gesture: gesture, folder: folder, geometry: geometry)
                        }
                        .onEnded { _ in
                            if let destinationFolder = dragAndDropViewModel.onDragEndedFolder(folder: folder, context: context) {
                                withAnimation(.easeIn) {
                                    coreDataViewModel.folderManager.moveFolder(parentFolder: parentFolder, movingFolder: folder, destinationFolder: destinationFolder)
                                    dragAndDropViewModel.folderOffsets[folder.id!] = .zero
                                }
                            } else {
                                withAnimation(.bouncy) {
                                    dragAndDropViewModel.folderOffsets[folder.id!] = .zero
                                }
                            }
                        }
                )
                .onAppear {
                    let frame = geometry.frame(in: .global)
                    dragAndDropViewModel.folderFrames[folder.id!] = frame
                }
                .onChange(of: geometry.frame(in: .global)) { newFrame in
                    dragAndDropViewModel.folderFrames[folder.id!] = newFrame
                }
        }
    }
}

