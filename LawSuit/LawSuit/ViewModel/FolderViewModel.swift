//
//  FolderViewModel.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 15/08/24.
//

import Foundation
import SwiftUI


class FolderViewModel: ObservableObject {
    
    @Published public var openFolder: Folder?
    @Published public var path = FolderStack()
    
    func openFolder(folder: Folder) {
        withAnimation(.easeIn(duration: 0.1)) {
            self.path.push(folder)
            self.openFolder = folder
        }
    }
    
    func closeFolder() {
        withAnimation(.easeIn(duration: 0.1)) {
            let lastFolder = path.pop()
            print(lastFolder.name ?? "Sem nome")
            self.openFolder = path.top()
        }
    }
    
}
