//
//  DocumentView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import SwiftUI
import CoreData

struct DocumentView: View {
    
    @EnvironmentObject var folderViewModel: FolderViewModel

    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var client: Client
    
    var body: some View {
        VStack {
            if let openFolder = folderViewModel.openFolder {
                DocumentGridView(rootFolder: openFolder)
                    .padding()
            }
        }
        .onAppear {
            folderViewModel.openFolder = client.rootFolder
            

        }

    }
}

//#Preview {
//    DocumentView()
//        .environmentObject(CoreDataViewModel())
//        .environmentObject(FolderViewModel())
//}

