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
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    
    //MARK: Variáveis de estado
    @ObservedObject var lawsuit: Lawsuit
    
    @State var deleted = false
    @State var editLawSuit = false
    @State var lawsuitCategory: TagType? = nil
    @State var lawsuitAuthorSocialName = ""
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
        
        VStack {
            if !deleted {
                HStack(alignment: .top, spacing: 22) {
                    mainBlock
                    //                        .frame(maxHeight: .infinity)
                    
                    VStack(spacing: 10) {
                        
                        movimentationBlock
                            .frame(maxHeight: .infinity)
                        
                    }
                    .frame(maxHeight: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(minHeight: 150, maxHeight: 190)
                .frame(minWidth: 620)
                Divider()
                    .padding(.top, 8)
                VStack {
                    HStack {
                        
                        Button {
                            folderViewModel.closeFolder()
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .buttonStyle(PlainButtonStyle())
                        .font(.title2)
                        .disabled(folderViewModel.getPath().count() == 1)
                        
                        Text((folderViewModel.getPath().count() == 1 ? "Arquivos do Processo" : folderViewModel.getOpenFolder()?.name) ?? "Sem nome")
                            .font(.title3)
                            .bold()
                        Spacer()
                        if let openFolder = folderViewModel.getOpenFolder(){
                            DocumentActionButtonsView(folder: openFolder )
                        }
                        
                    }
                    .padding(.vertical, 5)
                    // MARK: - View/Grid de Pastas
                    DocumentView()
                }
                Spacer()
            }
        }
        .sheet(isPresented: $editLawSuit, content: {
            //MARK: CHAMAR A VIEW DE EDITAR PROCESSOOOO
            EditLawSuitView(lawsuit: lawsuit, deleted: $deleted)
                .frame(minWidth: 495)
        })
        .padding()
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
        .navigationTitle(folderViewModel.getPath().getItens().first?.name ?? "Sem nome")
    }
    
    func updateNames() {
        //Se o cliente do processo estiver no autor
        if lawsuit.authorID.hasPrefix("client:") {
            if let author = dataViewModel.coreDataManager.clientManager.fetchFromId(id: lawsuit.authorID),
               let defendant = dataViewModel.coreDataManager.entityManager.fetchFromID(id: lawsuit.defendantID) {
                lawsuitAuthorSocialName = author.socialName ?? "Sem nome"
                lawsuitDefendantName = defendant.name
            }
            //Se o cliente do processo estiver no reu
        } else {
            if let defendant = dataViewModel.coreDataManager.clientManager.fetchFromId(id: lawsuit.defendantID),
               let authorEntity = dataViewModel.coreDataManager.entityManager.fetchFromID(id: lawsuit.authorID),
            
            let author = authorEntity as? Client {
                
                lawsuitAuthorSocialName = author.socialName ?? author.name
                lawsuitDefendantName = defendant.name
            }
            
            
            //               let author = dataViewModel.coreDataManager.entityManager.fetchFromID(id: lawsuit.authorID) {
            //                lawsuitAuthorSocialName = author.socialName as! Client.socialName
            //                lawsuitDefendantName = defendant.name
            //            }
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
                //                					.padding(.bottom, 30)
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Autor")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .bold()
                        //Aqui agora lawsuit apenas tem um id, preciso fazer o fetch
                        
                        Text(lawsuitAuthorSocialName)
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
                        //                        if !lawsuitDefendantName.isEmpty {
                        Text(lawsuitDefendantName)
                            .font(.subheadline)
                            .bold()
                        //                                            }
                    }
                    Spacer()
                }
            }
        }
    }
    
    private var movimentationBlock: some View {
        BoxView {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Última Movimentação")
                            .font(.title2)
                            .bold()
                        Text(dataViewModel.coreDataManager.updateManager.getLatestUpdateDate(lawsuit: lawsuit)?.convertToString() ?? "Sem movimentações")
                            .font(.title3)
                            .bold()
                        HStack {
                            Button(action: {
                                
                            }, label: {
                                Text("Acessar JusBrasil")
                            })
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Movimentações Anteriores")
                                .font(.headline)
                                .foregroundStyle(Color(.secondaryLabelColor))
                            
                            ForEach(dataViewModel.coreDataManager.updateManager.sortUpdates(lawsuit: lawsuit).prefix(3)) { update in
                                Text(update.date?.convertToString() ?? "Sem movimentações")
                                    .font(.subheadline)
                                    .foregroundStyle(Color(.secondaryLabelColor))
                            }
                        }.padding(.top, 10)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 3)
            }
        }
    }
}
