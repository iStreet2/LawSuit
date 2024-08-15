//
//  FolderIconView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import SwiftUI

struct FolderIconView: View {
    
    @ObservedObject var folder: Folder
    
    var body: some View {
        VStack {
            Image("folder")
            Text(folder.name)
                .lineLimit(2)
        }
    }
}
//
//#Preview {
//    FolderIconView(folder: FolderExamples.folderExample())
//}
