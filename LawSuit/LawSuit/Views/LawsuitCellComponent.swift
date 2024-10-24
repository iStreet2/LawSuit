//
// LawsuitCellComponent2.swift
// LawSuit
//
// Created by Giovanna Micher on 03/09/24.
//
import Foundation
import SwiftUI
struct LawsuitCellComponent: View {
    
    //MARK: Variáveis de Estado
    @ObservedObject var client: Client
    @ObservedObject var lawyer: Lawyer
    @ObservedObject var lawsuit: Lawsuit
    @State var nsImage: NSImage?
    @State var deleteLawsuit: Bool = false
    @State var editLawsuit: Bool = false
    @State var deleted = false
    
    //MARK: ViewModels
    @EnvironmentObject var lawsuitViewModel: LawsuitViewModel
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                VStack(alignment: .leading) {
                    Text("\(lawsuit.authorName) X \(lawsuit.defendantName)")
                        .lineLimit(1)
                        .font(.callout)
                        .bold()
                    Text(lawsuit.number)
                        .lineLimit(1)
                        .font(.callout)
                        .foregroundStyle(Color(.gray))
                }
                .frame(width: geo.size.width * 0.258, height: 47, alignment: .leading)
                Spacer()
                TagViewComponent(tagType: TagType(s: lawsuit.category))
                    .frame(width: geo.size.width * 0.12, height: 47, alignment: .leading)
                Spacer()
                Group {
                    if lawsuit.isLoading {
                        ProgressView()
                            .scaleEffect(0.5, anchor: .center)
                            .frame(width: geo.size.width * 0.17, height: 30)
                    } else {
                        if let latestUpdateDate = dataViewModel.coreDataManager.updateManager.getLatestUpdateDate(lawsuit: lawsuit)?.convertToString() {
                            Text(latestUpdateDate)
                                .frame(width: geo.size.width * 0.163, height: 47, alignment: .leading)
                        } else {
                            Text("Sem atualizações")
                                .frame(width: geo.size.width * 0.163, height: 47, alignment: .leading)
                        }
                    }
                    HStack {
                        if let nsImage {
                            Image(nsImage: nsImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 26, height: 26)
                                .clipShape(Circle())
                        }
                        if let socialName = client.socialName {
                            Text(socialName)
                                .lineLimit(1)
                        } else {
                            Text(client.name)
                                .lineLimit(1)
                        }
                    }
                    .frame(width: geo.size.width * 0.163, height: 47, alignment: .leading)
                    Text(lawsuit.isDistributed ? "Distribuído" : "Não distribuído")
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, minHeight: 47, alignment: .leading)
                }
                .font(.callout)
                .bold()
            }
            .onAppear {
                nsImage = NSImage(data: client.photo ?? Data())
            }
            .onChange(of: client.photo) {
                nsImage = NSImage(data: client.photo ?? Data())
            }
            .padding(.horizontal, 20)
        }
//        .contextMenu {
//            Button {
//                deleteLawsuit.toggle()
//            } label: {
//                Image(systemName: "trash")
//                Text("Deletar")
//            }
//            Button {
//                editLawsuit.toggle()
//            } label: {
//                Image(systemName: "pencil")
//                Text("Editar")
//            }
//
//            
//        }
        .frame(minWidth: 777)
        .frame(height: 47)
        .alert(isPresented: $deleteLawsuit, content: {
            Alert(title: Text("Você tem certeza?"), message: Text("Excluir esse processo irá apagar todos os documentos relacionados a ele."), primaryButton: Alert.Button.destructive(Text("Apagar"), action: {
                if lawsuit.authorID.hasPrefix("client:") {
                    if let entity = dataViewModel.coreDataManager.entityManager.fetchFromID(id: lawsuit.defendantID) {
                        dataViewModel.coreDataManager.entityManager.deleteEntity(entity: entity)
                    }
                } else {
                    if let entity = dataViewModel.coreDataManager.entityManager.fetchFromID(id: lawsuit.authorID) {
                        dataViewModel.coreDataManager.entityManager.deleteEntity(entity: entity)
                    }
                }
                dataViewModel.coreDataManager.lawsuitManager.deleteLawsuit(lawsuit: lawsuit)
            }), secondaryButton: Alert.Button.cancel(Text("Cancelar"), action: {
            }))
        })
        .sheet(isPresented: $editLawsuit) {
            EditLawSuitView(lawsuit: lawsuit, deleted: $deleted)
        }
    }
}








