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
    //    @Binding var showingGridView: Bool
    
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
            sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name, ascending: true)]
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
                    dragAndDropViewModel.handleDrop(providers: providers, parentFolder: parentFolder, destinationFolder: folder, context: context, dataViewModel: dataViewModel)
                    return true
                }
                .transition(.scale)
        }
    }
}

