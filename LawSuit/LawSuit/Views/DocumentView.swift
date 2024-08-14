//
//  DocumentView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import SwiftUI
import CoreData

struct DocumentView: View {
    
//    @ObservedObject var rootFolder: Folder
    
    var folders: [Folder]
    
    
    var body: some View {
        VStack {
            ForEach(folders, id: \.self) { folder in
                Text(folder.name)
            }
        }
        .padding(100)
    }
}

#Preview {
    DocumentView(folders: FolderExamples.foldersExample())
}

