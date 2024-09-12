//
//  EditLawSuitView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 30/08/24.
//

import SwiftUI

struct EditLawSuitView: View {
    
    //MARK: Variáveis de ambiente
    @Environment(\.dismiss) var dismiss
    
    
    //MARK: Variáveis de estado
    @State var lawsuitNumber = ""
    @State var lawsuitCourt = ""
    @State var lawsuitAuthorName = ""
    @State var lawsuitDefendantName = ""
    @State var lawsuitActionDate = Date()
    @State var selectTag = false
    @State var tagType: TagType = .trabalhista
    @ObservedObject var lawsuit: Lawsuit
    @Binding var deleted: Bool
    @State var attributedAuthor = false
    @State var attributedDefendant = false
    @State var entityID = ""
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack {
            LabeledTextField(label: "Nº do Processo", placeholder: "", textfieldText: $lawsuitNumber)
            LabeledTextField(label: "Vara", placeholder: "", textfieldText: $lawsuitCourt)
            HStack(alignment: .top, spacing: 70) {
                VStack(alignment: .leading) {
                    //MARK: Caso usuário não selecionou nada ainda
                    if !attributedDefendant {
                        EditLawsuitAuthorComponent(button: "Atribuir cliente", label: "Autor", lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, authorOrDefendant: "author", attributedAuthor: $attributedAuthor, attributedDefendant: $attributedDefendant)
                    }
                    //MARK: Caso usuário atribuir cliente para o réu
                    if attributedDefendant {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Autor")
                                    .bold()
                            }
                        }
                        TextField("", text: $lawsuitAuthorName)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                    }
                    HStack {
                        //MARK: Caso o usuário tenha adicionado um cliente no autor
                        if attributedAuthor {
                            Text("\(lawsuitAuthorName)")
                            Button {
                                withAnimation {
                                    //Retirar esse cliente e retirar o estado de autor selecionado
                                    attributedAuthor = false
                                    lawsuitAuthorName = ""
                                }
                            } label: {
                                Image(systemName: "minus")
                            }
                            .padding(.leading, 5)
                        }
                    }
                    .frame(width: 200, alignment: .leading)
                    Text("Área")
                        .padding(.top)
                        .bold()
                    TagViewComponent(tagType: tagType)
                        .onTapGesture {
                            selectTag.toggle()
                        }
                    Spacer()
                    Button(action: {
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
                        deleted.toggle()
                        dismiss()
                    }, label: {
                        Text("Apagar processo")
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
                Spacer()
                VStack(alignment: .leading) {
                    //MARK: Se o usuário não selecionou nada
                    if !attributedAuthor {
                        EditLawsuitAuthorComponent(button: "Atribuir cliente", label: "Réu", lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, authorOrDefendant: "defendant", attributedAuthor: $attributedAuthor, attributedDefendant: $attributedDefendant)
                    }
                    //MARK: Caso o usuário tenha adicionado um cliente no autor
                    if attributedAuthor {
                        VStack(alignment: .leading){
                            HStack{
                                Text("Réu")
                                    .bold()
                            }
                        }
                        TextField("", text: $lawsuitDefendantName)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                    }
                    HStack {
                        //MARK: Caso o usuário tenha adicionado um cliente no réu
                        if attributedDefendant {
                            Text(lawsuitDefendantName)
                            Button {
                                withAnimation {
                                    //Retirar esse cliente e retirar o estado de autor selecionado
                                    attributedDefendant = false
                                    lawsuitDefendantName = ""
                                }
                            } label: {
                                Image(systemName: "minus")
                            }
                            .padding(.leading,2)
                        }
                    }
                    .frame(width: 200, alignment: .leading)
                    LabeledDateField(selectedDate: $lawsuitActionDate, label: "Data da distribuição")
                        .padding(.top)
                    HStack(spacing: 10) {
                        Spacer()
                        Button(action: {
                            //resetar os valores
                            dismiss()
                        }, label: {
                            Text("Cancelar")
                        })
                        Button(action: {
                            if attributedAuthor {
                                if let author = dataViewModel.coreDataManager.clientManager.fetchFromName(name: lawsuitAuthorName) {
                                    if let defendant = dataViewModel.coreDataManager.entityManager.fetchFromID(id: entityID) {
                                        //MARK: CoreData
                                        dataViewModel.coreDataManager.entityManager.editEntity(entity: defendant, name: lawsuitDefendantName)
                                        let category = TagTypeString.string(from: tagType)
                                        dataViewModel.coreDataManager.lawsuitManager.editLawSuit(lawsuit: lawsuit, name: "\(lawsuitAuthorName) X \(lawsuitDefendantName)", number: lawsuitNumber, court: lawsuitCourt, category: category, defendantID: defendant.id, authorID: author.id, actionDate: lawsuitActionDate)
                                        
                                        //MARK: CloudKit
                                        let propertyNames = ["name","number","court","category","defendantID","authorID","actionDate"]
                                        let propertyValues: [Any] = ["\(lawsuitAuthorName) X \(lawsuitDefendantName)", lawsuitNumber, lawsuitCourt, category, defendant.id, author.id, lawsuitActionDate]
                                        Task {
                                            try await dataViewModel.cloudManager.recordManager.updateObjectInCloudKit(object: defendant, propertyNames: ["name"], propertyValues: [lawsuitDefendantName])
                                            try await dataViewModel.cloudManager.recordManager.updateObjectInCloudKit(object: lawsuit, propertyNames: propertyNames, propertyValues: propertyValues)
                                        }
                                        dismiss()
                                    }
                                    
                                } else {
                                    print("error achando ou author")
                                }
                            } else if attributedDefendant {
                                if let defendant = dataViewModel.coreDataManager.clientManager.fetchFromName(name: lawsuitDefendantName) {
                                    if let author = dataViewModel.coreDataManager.entityManager.fetchFromID(id: entityID) {
                                        //MARK: CoreData
                                        dataViewModel.coreDataManager.entityManager.editEntity(entity: author, name: lawsuitAuthorName)
                                        let category = TagTypeString.string(from: tagType)
                                        dataViewModel.coreDataManager.lawsuitManager.editLawSuit(lawsuit: lawsuit, name: "\(lawsuitAuthorName) X \(lawsuitDefendantName)", number: lawsuitNumber, court: lawsuitCourt, category: category, defendantID: defendant.id, authorID: author.id, actionDate: lawsuitActionDate)
                                        
                                        //MARK: CloudKit
                                        let propertyNames = ["name","number","court","category","defendantID","authorID","actionDate"]
                                        let propertyValues: [Any] = ["\(lawsuitAuthorName) X \(lawsuitDefendantName)", lawsuitNumber, lawsuitCourt, category, defendant.id, author.id, lawsuitActionDate]
                                        Task {
                                            try await dataViewModel.cloudManager.recordManager.updateObjectInCloudKit(object: author, propertyNames: ["name"], propertyValues: [lawsuitAuthorName])
                                            try await dataViewModel.cloudManager.recordManager.updateObjectInCloudKit(object: lawsuit, propertyNames: propertyNames, propertyValues: propertyValues)
                                        }
                                        dismiss()
                                    }
                                    
                                } else {
                                    print("error achando defendant")
                                }
                            }
                        }, label: {
                            Text("Salvar")
                        })
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.top)
                }
            }
        }
        .sheet(isPresented: $selectTag, content: {
            VStack {
                Spacer()
                TagViewPickerComponentV1(currentTag: $tagType)
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        selectTag.toggle()
                    }, label: {
                        Text("Salvar")
                    })
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
            .frame(minWidth: 200, minHeight: 250)
        })
        .onAppear {
            //Se o cliente do processo estiver no autor
            if lawsuit.authorID.hasPrefix("client:") {
                attributedAuthor = true
                if let author = dataViewModel.coreDataManager.clientManager.fetchFromId(id: lawsuit.authorID),
                   let defendant = dataViewModel.coreDataManager.entityManager.fetchFromID(id: lawsuit.defendantID) {
                    lawsuitAuthorName = author.name
                    lawsuitDefendantName = defendant.name
                    self.entityID = defendant.id
                }
            //Se o cliente do processo estiver no reu
            } else {
                attributedDefendant = true
                if let defendant = dataViewModel.coreDataManager.clientManager.fetchFromId(id: lawsuit.defendantID),
                   let author = dataViewModel.coreDataManager.entityManager.fetchFromID(id: lawsuit.authorID) {
                    lawsuitAuthorName = author.name
                    lawsuitDefendantName = defendant.name
                    self.entityID = author.id
                }
            }
            lawsuitNumber = lawsuit.number
            lawsuitCourt = lawsuit.court
            lawsuitActionDate = lawsuit.actionDate
            tagType = TagType(s: lawsuit.category)!
        }
        .padding()
    }
    
}

