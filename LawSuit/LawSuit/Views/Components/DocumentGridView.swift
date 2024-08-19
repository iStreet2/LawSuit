//
//  DocumentGridView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 15/08/24.
//

import SwiftUI

struct DocumentGridView: View {
    
    //MARK: Variáveis de estado
    var parentFolder: Folder
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var dragAndDropViewModel: DragAndDropViewModel
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @FetchRequest var folders: FetchedResults<Folder>
    
    init(parentFolder: Folder) {
        self.parentFolder = parentFolder
        _folders = FetchRequest<Folder>(
            sortDescriptors: []
            ,predicate: NSPredicate(format: "parentFolder == %@", parentFolder)
        )
    }
    
    //MARK: Calculo da grid
    let spacing: CGFloat = 10
    let itemWidth: CGFloat = 90
    
    var body: some View {
        GeometryReader { geometry in
            let columns = Int(geometry.size.width / (itemWidth + spacing))
            let gridItems = Array(repeating: GridItem(.flexible(), spacing: spacing), count: max(columns, 1))
            ScrollView {
                VStack {
                    LazyVGrid(columns: gridItems, spacing: spacing) {
                        ForEach(folders, id: \.self) { folder in
                            FolderIconView(folder: folder, parentFolder: parentFolder)
                                .onTapGesture(count: 2) {
                                    folderViewModel.openFolder(folder: folder)
                                }
                                .padding(.leading)
                        }
                    }
                }
            }
        }
    }
}
