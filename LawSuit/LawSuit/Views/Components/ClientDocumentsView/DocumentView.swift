//
//  DocumentView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 11/09/24.
//

import Foundation
import SwiftUI

struct DocumentView: View{
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    
    //MARK: Variáveis
    @State private var showingGridView = true

    var body: some View{
        if let openFolder = folderViewModel.getOpenFolder(){
            VStack{
                HStack{
                    Button {
                        showingGridView = true
                    } label: {
                        Image(systemName: "square.grid.2x2")
                    }
                    
                    Button(action: {
                        showingGridView = false
                    }, label: {
                        Image(systemName: "list.bullet")
                    })
                }
            }
            
            if showingGridView {
                DocumentGridView(folder: openFolder)
            } else {
                DocumentListView(folder: openFolder)
            }
        }
    }
}

#Preview {
    DocumentView()
}
