//
//  SideBarView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 27/08/24.
//

import SwiftUI

struct SideBarView: View {
    
    //MARK: ViewModels:
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var dataViewModel: DataViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    
    //MARK: Variáveis de estado
    @Binding var selectedView: SelectedView
    @Binding var navigationVisibility: NavigationSplitViewVisibility
    
    var body: some View {
        VStack {
            ZStack {
                if selectedView == .clients {
                    Color.white
                        .opacity(0.2)
                        .cornerRadius(10)
                }
                Image(systemName: "person.2")
                    .font(.system(size: 19))
                    .foregroundStyle(.white)
            }
            .frame(width: 55, height: 46)
            .onTapGesture {
                withAnimation(.bouncy) {
                    selectedView = .clients
                    navigationViewModel.isShowingDetailedLawsuitView = false
                    
                    if let selectedClient = navigationViewModel.selectedClient {
                        folderViewModel.resetFolderStack()
                        folderViewModel.openFolder(folder: selectedClient.rootFolder)
                    }
                    navigationVisibility = .all
                }
            }
            ZStack {
                if selectedView == .lawsuits {
                    Color.white
                        .opacity(0.2)
                        .cornerRadius(10)
                }
                Image(systemName: "briefcase")
                    .font(.system(size: 19))
                    .foregroundStyle(.white)
            }
            .frame(width: 55, height: 46)
            .onTapGesture {
                withAnimation(.bouncy) {
                    selectedView = .lawsuits
                    navigationViewModel.isShowingDetailedLawsuitView = false
                }
            }
            Spacer()
        }
        .padding()
        .padding(.trailing,5)
        .background(Color(hex: "932425").blendMode(.multiply))
    }
}

