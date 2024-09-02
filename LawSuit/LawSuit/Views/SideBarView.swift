//
//  SideBarView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 27/08/24.
//

import SwiftUI

struct SideBarView: View {
    
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    
    @Binding var selectedView: SelectedView
    
    var body: some View {
        VStack {
            ZStack {
                if selectedView == .clients {
                    Color.gray
                        .opacity(0.3)
                        .cornerRadius(10)
                }
                Image(systemName: "person.2")
                    .font(.system(size: 19))
                    .onTapGesture {
                        withAnimation(.bouncy) {
                            selectedView = .clients
                            if let selectedClient = coreDataViewModel.clientManager.selectedClient {
                                folderViewModel.resetFolderStack()
                                folderViewModel.openFolder(folder: selectedClient.rootFolder)
                            }
                            //Necessário ação para mudar tela
                        }
                    }
            }
            .frame(width: 55, height: 46)
            ZStack {
                if selectedView == .lawsuits {
                    Color.gray
                        .opacity(0.3)
                        .cornerRadius(10)
                }
                Image(systemName: "briefcase")
                    .font(.system(size: 19))
                    .onTapGesture {
                        withAnimation(.bouncy) {
                            selectedView = .lawsuits
                            //Necessário ação para mudar a tela
                        }
                    }
            }
            .frame(width: 55, height: 46)
            Spacer()
        }
        .padding()
    }
    
    
    
    
    
    
    
}
