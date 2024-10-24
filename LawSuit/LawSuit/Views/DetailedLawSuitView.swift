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
    @EnvironmentObject var lawsuitViewModel: LawsuitViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var folderViewModel: FolderViewModel
    //MARK: Variáveis de estado
    @ObservedObject var lawsuit: Lawsuit
    
    @State var deleted = false
    @State var editLawSuit = false
    @State var lawsuitCategory: TagType
    @State var isCopied = false
    @ObservedObject var client: Client
    @ObservedObject var entity: Entity
    @State var lawsuitAuthorName: String = ""
    @State var lawsuitAuthorSocialName: String = ""
    @State var lawsuitDefendantName: String = ""
    @State var showingGridView = true
    @State var selectedSegment: String = "Movimentações"
    @State var note: String = ""
    var infos = ["Movimentações", "Notas"]
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var clients: FetchedResults<Client>
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                if !deleted {
                    HStack(alignment: .top, spacing: 22) {
                        mainBlock
                        VStack(spacing: 10) {
                            //                            activeSegment
                            MovimentationBlock(dataViewModel: _dataViewModel, lawsuit: lawsuit)
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
                    
                    // MARK: - View/Grid de Pastas
                    DocumentView()
                    
                }
            }
            
            if isCopied {
                Text("Copiado para área de transferência!")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                isCopied = false
                            }
                        }
                    }
            }
        }
        .onDisappear {
            navigationViewModel.isShowingDetailedLawsuitView = false
        }
        .sheet(isPresented: $editLawSuit, content: {
            //MARK: CHAMAR A VIEW DE EDITAR PROCESSOOOO
            EditLawSuitView(tagType: $lawsuitCategory, lawsuit: lawsuit, deleted: $deleted)
            //            EditLawSuitView( tagType: $lawsuitCategory, lawsuit: lawsuit, deleted: $deleted, authorRowState: lawsuitAuthorName, defendantRowState: lawsuitDefendantName)
                .frame(minWidth: 495)
        })
        .onAppear {
            folderViewModel.resetFolderStack()
            folderViewModel.openFolder(folder: lawsuit.rootFolder)
            navigationViewModel.isShowingDetailedLawsuitView = true
        }
        .onChange(of: deleted) { _ in
            dismiss()
        }
        .onChange(of: navigationViewModel.isShowingDetailedLawsuitView, perform: { newValue in
            if !newValue {
                dismiss()
            }
        })
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
        print("author: \(lawsuitAuthorName), reu: \(lawsuitDefendantName)")
    }
}


extension DetailedLawSuitView {
    private var mainBlockHeader: some View {
        HStack {
            TagViewComponent(tagType: TagType(s: lawsuit.category) ?? TagType.ambiental)
            Spacer()
            HStack {
                Button {
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
    }
    
    private var mainBlockNumber: some View {
        HStack {
            Text(lawsuit.number)
                .font(.title3)
                .bold()
            Button {
                lawsuit.number.copy()
                isCopied = true
                print("foi copiado? \(isCopied)")
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
                Text("\(lawsuit.actionDate.convertBirthDateToString())")
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Autor")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .bold()
                        //Aqui agora lawsuit apenas tem um id, preciso fazer o fetch
                        Button {
                            let authorIsEntity = dataViewModel.coreDataManager.entityManager.authorIsEntity(lawsuit: lawsuit)
                            if authorIsEntity {
                                print("Authro is entity")
                                withAnimation(.bouncy()) {
                                    navigationViewModel.navigationVisibility = .all
                                    navigationViewModel.selectedClient = dataViewModel.coreDataManager.clientManager.fetchFromName(name: entity.name)
                                    navigationViewModel.selectedView = .clients
                                }
                            } else {
                                withAnimation(.bouncy()) {
                                    navigationViewModel.navigationVisibility = .all
                                    navigationViewModel.selectedClient = client
                                    navigationViewModel.selectedView = .clients
                                }
                            }
                        } label: {
                            Text((dataViewModel.coreDataManager.entityManager.authorIsEntity(lawsuit: lawsuit) ? entity.name : client.socialName) ?? client.name)
                                .font(.subheadline)
                                .bold()
                                .underline(dataViewModel.coreDataManager.entityManager.authorIsEntity(lawsuit: lawsuit))
                        }
                        
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Réu")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .bold()
                        //Aqui agora lawsuit apenas tem um id, preciso fazer o fetch
                        //                        if !lawsuitDefendantName.isEmpty {
                        Text(dataViewModel.coreDataManager.entityManager.authorIsEntity(lawsuit: lawsuit) ? client.socialName ?? client.name : entity.name)
                        // Text(lawsuitDefendantName)
                            .font(.subheadline)
                            .bold()
                        //                                            }
                    }
                    Spacer()
                }
            }
        }
    }
//    private var activeSegment: some View{
//                BoxView{
//                    VStack(alignment: .leading) {
//                        CustomSegmentedControl(selectedOption: $selectedSegment, infos: infos)
//        
//                        if selectedSegment == "Movimentações" {
//                            MovimentationBlock(dataViewModel: _dataViewModel, lawsuit: lawsuit)
//                        }
//                        else {
//                            NoteBlock(note: $note, placeholder: "Notas")
//        
//                        }
//                    }
//                }
//    }
}









