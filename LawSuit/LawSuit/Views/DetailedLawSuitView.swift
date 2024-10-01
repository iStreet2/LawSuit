//
//  ProcessView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 29/08/24.
//

import Foundation
import SwiftUI

struct DetailedLawSuitView: View {
    
    //MARK: Variáveis de ambiente
    @Environment(\.dismiss) var dismiss
    
    //MARK: ViewModels
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var folderViewModel: FolderViewModel
    //MARK: Variáveis de estado
    @ObservedObject var lawsuit: Lawsuit
    
    @State var deleted = false
    @State var editLawSuit = false
    @State var lawsuitCategory: TagType? = nil
    @State var lawsuitAuthorName = ""
    @State var lawsuitDefendantName = ""
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy" // Personaliza o formato da data
        return formatter
    }
    @State var showingGridView = true
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var clients: FetchedResults<Client>
    
    var body: some View {
        
            VStack(alignment: .leading, spacing: 0) {
                if !deleted {
                    HStack(alignment: .top, spacing: 22) {
                        mainBlock
                        
                        VStack(spacing: 10) {
                            MovimentationBlock(dataViewModel: _dataViewModel, lawsuit: lawsuit)
                                .frame(maxHeight: .infinity)
                        }
                        .frame(maxHeight: .infinity)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(minHeight: 150, maxHeight: 190)
                    .frame(minWidth: 620)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 13)
                    
                    Divider()
                    
                    LawsuitFoldersHeaderComponent()
                        .padding(.vertical, 10)
                    
                    Divider()
                    
                    // MARK: - View/Grid de Pastas
                    DocumentView()
                                        
                    PathViewComponent()
                }
            }
            
   
        .sheet(isPresented: $editLawSuit, content: {
            //MARK: CHAMAR A VIEW DE EDITAR PROCESSOOOO
            EditLawSuitView(lawsuit: lawsuit, deleted: $deleted)
                .frame(minWidth: 495)
        })
        .onAppear {
            folderViewModel.resetFolderStack()
            folderViewModel.openFolder(folder: lawsuit.rootFolder)
            updateNames()
        }
        .onChange(of: lawsuit.authorID) { _ in
            updateNames()
        }
        .onChange(of: lawsuit.defendantID) { _ in
            updateNames()
        }
        .onChange(of: deleted) { _ in
            dismiss()
        }
        .onChange(of: navigationViewModel.dismissLawsuitView) { _ in
            navigationViewModel.dismissLawsuitView.toggle()
            dismiss()
        }
        .border(Color.green)
        .navigationTitle(folderViewModel.getPath().getItens().first?.name ?? "Sem nome")
    }
    
    func updateNames() {
        //Se o cliente do processo estiver no autor
        if lawsuit.authorID.hasPrefix("client:") {
            if let author = dataViewModel.coreDataManager.clientManager.fetchFromId(id: lawsuit.authorID),
               let defendant = dataViewModel.coreDataManager.entityManager.fetchFromID(id: lawsuit.defendantID) {
                lawsuitAuthorName = author.name
                lawsuitDefendantName = defendant.name
            }
            //Se o cliente do processo estiver no reu
        } else {
            if let defendant = dataViewModel.coreDataManager.clientManager.fetchFromId(id: lawsuit.defendantID),
               let author = dataViewModel.coreDataManager.entityManager.fetchFromID(id: lawsuit.authorID) {
                lawsuitAuthorName = author.name
                lawsuitDefendantName = defendant.name
            }
        }
    }
}

extension DetailedLawSuitView {
    private var mainBlockHeader: some View {
        HStack {
            TagViewComponent(tagType: TagType(s: lawsuit.category) ?? .trabalhista)
            Spacer()
            Button {
                // editar
                editLawSuit.toggle()
            } label: {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 21)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var mainBlockNumber: some View {
        HStack {
            Text(lawsuit.number)
                .font(.title3)
                .bold()
            Button {
                // copiar o número para o clipboard
            } label: {
                Image(systemName: "rectangle.portrait.on.rectangle.portrait")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var mainBlock: some View {
        BoxView {
            VStack(alignment: .leading) {
                mainBlockHeader
                
                mainBlockNumber
                
                Text(lawsuit.court)
                
                Text("Distribuição da ação")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .bold()
                //                Text(dateFormatter.string(from: lawsuit.actionDate))
                Text("\(lawsuit.actionDate, formatter: dateFormatter)")
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Autor")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .bold()
                        //Aqui agora lawsuit apenas tem um id, preciso fazer o fetch
                        Text(lawsuitAuthorName)
                            .font(.subheadline)
                            .bold()
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Réu")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .bold()
                        //Aqui agora lawsuit apenas tem um id, preciso fazer o fetch
                        Text(lawsuitDefendantName)
                            .font(.subheadline)
                            .bold()
                    }
                    Spacer()
                }
            }
        }
    }
}
