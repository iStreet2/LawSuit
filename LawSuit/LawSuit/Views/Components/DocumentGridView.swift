//
//  DocumentGridView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 15/08/24.
//

import SwiftUI

struct DocumentGridView: View {
    
    //MARK: Variáveis de estado
    @ObservedObject var rootFolder: Folder
    
    @EnvironmentObject var folderViewModel: FolderViewModel
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @FetchRequest var folders: FetchedResults<Folder>
    
    init(rootFolder: Folder) {
        self.rootFolder = rootFolder
        _folders = FetchRequest<Folder>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "parentFolder == %@", rootFolder)
        )
    }
    
    //MARK: Calculo da grid
    let spacing: CGFloat = 10
    let itemWidth: CGFloat = 70
    
    var body: some View {
        GeometryReader { geometry in
            let columns = Int(geometry.size.width / (itemWidth + spacing))
            let gridItems = Array(repeating: GridItem(.flexible(), spacing: spacing), count: max(columns, 1))
            NavigationStack {
                ScrollView {
                    VStack {
                        LazyVGrid(columns: gridItems, spacing: spacing) {
                            ForEach(folders, id: \.self) { folder in
                                FolderIconView(folder: folder)
                                    .onTapGesture(count: 2) {
                                        folderViewModel.openFolder(folder: folder)
                                    }
                            }
                        }
                    }
                }
            }
        }    }
}

//#Preview {
//    DocumentGridView(rootFolder: FolderExamples.folderExample())
//        .environmentObject(CoreDataViewModel())
//        .environmentObject(FolderViewModel())
//}
