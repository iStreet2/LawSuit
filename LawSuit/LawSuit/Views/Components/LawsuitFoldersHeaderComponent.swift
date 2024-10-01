//
//  LawsuitFoldersHeaderComponent.swift
//  LawSuit
//
//  Created by Giovanna Micher on 30/09/24.
//

import SwiftUI

struct LawsuitFoldersHeaderComponent: View {
    @EnvironmentObject var folderViewModel: FolderViewModel
    
    var isFirstFolderOpen: Bool {
        return folderViewModel.getPath().count() == 1
    }
    
    var buttonColor: Color {
        return isFirstFolderOpen ? Color(NSColor.quaternaryLabelColor) : Color(.black)
    }
    
    var body: some View {
        HStack {
            Button {
                folderViewModel.closeFolder()
            } label: {
                Image(systemName: "chevron.left")
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(buttonColor)
            .font(.title2)
            .disabled(folderViewModel.getPath().count() == 1)
            
            
            Text((folderViewModel.getPath().count() == 1 ? "Arquivos do Processo" : folderViewModel.getOpenFolder()?.name) ?? "Sem nome")
                .font(.title3)
                .bold()
            Spacer()
            if let openFolder = folderViewModel.getOpenFolder(){
                DocumentActionButtonsView(folder: openFolder)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    LawsuitFoldersHeaderComponent()
}
