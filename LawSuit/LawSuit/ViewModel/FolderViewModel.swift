//
//  FolderViewModel.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 15/08/24.
//

import Foundation
import SwiftUI


class FolderViewModel: ObservableObject {
    
    @Published public var openFile: FilePDF?
    @Published public var openFolder: Folder?
    @Published public var path = FolderStack()
    
    func openFolder(folder: Folder) {
        withAnimation(.easeIn(duration: 0.1)) {
            self.openFolder = folder
            self.path.push(folder)
        }
    }
    
    func closeFolder() {
        withAnimation(.easeIn(duration: 0.1)) {
            let lastFolder = path.pop()
            print(lastFolder.name)
            self.openFolder = path.top()
        }
    }
    
}
