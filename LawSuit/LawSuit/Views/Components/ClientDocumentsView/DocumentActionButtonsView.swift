//
//  DocumentActionButtonsView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 16/09/24.
//
import Foundation
import SwiftUI

struct DocumentActionButtonsView: View {
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    
    //MARK: Viariáveis
    var folder: Folder
    
    var body: some View {
        HStack{
            Button {
                folderViewModel.showingGridView = true
            } label: {
                Image(systemName: "square.grid.2x2")
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color.gray)
                            .opacity(folderViewModel.showingGridView ? 0.4 : 0.0)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                folderViewModel.showingGridView = false
            }, label: {
                Image(systemName: "list.bullet")
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color.gray)
                            .opacity(folderViewModel.showingGridView ? 0.0 : 0.4) 

                    )
            })
            .buttonStyle(PlainButtonStyle())
            .foregroundStyle(.gray)
            
            
            Menu(content: {
                Button {
                    dataViewModel.coreDataManager.folderManager.createFolder(parentFolder: folder, name: "Nova Pasta")
                } label: {
                    Text("Nova Pasta")
                    Image(systemName: "folder")
                }
                Button {
                    folderViewModel.importPDF(parentFolder: folder, dataViewModel: dataViewModel)
                } label: {
                    Text("Importar PDF")
                    Image(systemName: "doc")
                }
            }, label: {
                Image(systemName: "plus")
                    .foregroundStyle(Color(.gray))
            })
            .buttonStyle(PlainButtonStyle())
        }
        .font(.title2)
        .foregroundStyle(Color(.gray))
        .padding(.trailing)
        
    }
}


