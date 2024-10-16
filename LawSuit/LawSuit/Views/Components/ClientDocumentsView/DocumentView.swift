//
//  DocumentView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 11/09/24.
//

import Foundation
import SwiftUI

struct DocumentView: View {
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var dataViewModel: DataViewModel
    
    //MARK: Variáveis
//    @Binding var showingGridView: Bool
    
    var body: some View{
        if let openFolder = folderViewModel.getOpenFolder(){
            if folderViewModel.showingGridView  {
                Divider()
                DocumentGridView(openFolder: openFolder)
                PathViewComponent(openFolder: openFolder)
            } else {
                DocumentListView(openFolder: openFolder)
                PathViewComponent(openFolder: openFolder)
            }
        }
    }
}


