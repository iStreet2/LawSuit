//
//  EditLawSuitView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 30/08/24.

import SwiftUI
import CloudKit
import Combine

struct EditLawSuitView: View {
    
    //MARK: Variáveis de ambiente
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var textFieldDataViewModel: TextFieldDataViewModel
    
    //MARK: Variáveis de estado
    @State var invalidInformation: InvalidInformation?
    @State var lawsuitNumber = ""
    @State var lawsuitCourt = ""
    @State var lawsuitAuthorName = ""
    @State var lawsuitDefendantName = ""
    @State var lawsuitActionDate = Date()
    @State var selectTag = false
    @State var tagType: TagType = .trabalhista
    @ObservedObject var lawsuit: Lawsuit
    @Binding var deleted: Bool
    @State var deleteAlert = false
    @State var attributedAuthor = false
    @State var attributedDefendant = false
    @State var entityID = ""
    let textLimit = 100
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack {
            LabeledTextField(label: "Nº do Processo", placeholder: "", textfieldText: $lawsuitNumber)
                .onReceive(Just(lawsuitNumber)) { _ in lawsuitNumber = textFieldDataViewModel.lawSuitNumberValidation(lawsuitNumber) }
            LabeledTextField(label: "Vara", placeholder: "", textfieldText: $lawsuitCourt)
            HStack(alignment: .top, spacing: 70) {
                VStack(alignment: .leading) {
                    //MARK: Caso usuário não selecionou nada ainda
                    if !attributedDefendant {
                        EditLawsuitAuthorComponent(button: "Atribuir cliente", label: "Autor", lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, authorOrDefendant: "author", attributedAuthor: $attributedAuthor, attributedDefendant: $attributedDefendant)
                    }
                    
                    //MARK: Caso usuário atribuir cliente para o réu
                    if attributedDefendant {
                        LabeledTextField(label: "Autor", placeholder: "Adicionar autor", textfieldText: $lawsuitAuthorName)
                            .onReceive(Just(lawsuitAuthorName)) { _ in textFieldDataViewModel.limitText(text: &lawsuitAuthorName, upper: textLimit) }
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
                }
                .frame(width: 200, alignment: .leading)
                VStack(alignment: .leading) {
                    if !attributedAuthor {
                        EditLawsuitAuthorComponent(button: "Atribuir cliente", label: "Réu", lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, authorOrDefendant: "defendant", attributedAuthor: $attributedAuthor, attributedDefendant: $attributedDefendant)
                    }
                    //MARK: Caso o usuário tenha adicionado um cliente no autor
                    if attributedAuthor {
                        LabeledTextField(label: "Réu", placeholder: "Adicionar réu", textfieldText: $lawsuitDefendantName)
                            .onReceive(Just(lawsuitDefendantName)) { _ in textFieldDataViewModel.limitText(text: &lawsuitDefendantName, upper: textLimit) }
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
                }
                .frame(width: 200, alignment: .leading)
            }
            HStack(alignment: .top, spacing: 70) {
                VStack(alignment: .leading) {
                    Text("Área")
                        .padding(.top)
                        .bold()
                    TagViewComponent(tagType: tagType)
                        .onTapGesture {
                            selectTag.toggle()
                        }
                }
                Spacer()
                VStack(alignment: .leading) {
                    LabeledDateField(selectedDate: $lawsuitActionDate, label: "Data da distribuição")
                        .padding(.top)
                        .frame(width: 200, alignment: .leading)
                    
                }
            }
            Spacer()
            HStack(alignment: .top, spacing: 70) {
                Button(action: {
                    deleteAlert.toggle()
                }, label: {
                    Text("Apagar processo")
                })
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .alert(isPresented: $deleteAlert, content: {
                    Alert(title: Text("Você tem certeza?"), message: Text("Excluir esse processo irá apagar todos os documentos relacionados a ele."), primaryButton: Alert.Button.destructive(Text("Apagar"),
                    action: {
                        let recordName = lawsuit.recordName
                        let rootFolder = lawsuit.rootFolder
                        
                        //MARK: CoreData - Deletar
                        Task {
                            if dataViewModel.coreDataManager.clientManager.authorIsClient(lawsuit: lawsuit) {
                                if let entity = dataViewModel.coreDataManager.entityManager.fetchFromID(id: lawsuit.defendantID) {
                                    dataViewModel.coreDataManager.entityManager.deleteEntity(entity: entity)
                                    try await dataViewModel.cloudManager.recordManager.deleteObjectInCloudKit(object: entity) //CloudKit
                                }
                            } else {
                                if let entity = dataViewModel.coreDataManager.entityManager.fetchFromID(id: lawsuit.authorID) {
                                    dataViewModel.coreDataManager.entityManager.deleteEntity(entity: entity)
                                    try await dataViewModel.cloudManager.recordManager.deleteObjectInCloudKit(object: entity) //CloudKit
                                }
                            }
                        }
                        dataViewModel.coreDataManager.lawsuitManager.deleteLawsuit(lawsuit: lawsuit)
                        Task {
                            //MARK: CloudKit - Deletar
                            if let recordName = recordName, let rootFolder = rootFolder {
                                try await dataViewModel.cloudManager.recordManager.deleteLawsuitOrClientWithRecordName(recordName: recordName, rootFolder: rootFolder)
                            }
                        }
                        
                        deleted.toggle()
                        dismiss()
                    }), secondaryButton: Alert.Button.cancel(Text("Cancelar"), action: {
                    }))
                })
                Spacer()
                HStack(spacing: 10) {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancelar")
                    })
                    Button(action: {
                        if !areFieldsFilled() {
                            invalidInformation = .missingInformation
                            return
                        }
                        if lawsuitNumber.count < 25 {
                            invalidInformation = .invalidLawSuitNumber
                            return
                        }
                        if attributedAuthor {
                                if let author = dataViewModel.coreDataManager.clientManager.fetchFromName(name: lawsuitAuthorName) {
                                    if let defendant = dataViewModel.coreDataManager.entityManager.fetchFromID(id: entityID) {
                                        //MARK: CoreData - Editar
                                        dataViewModel.coreDataManager.entityManager.editEntity(entity: defendant, name: lawsuitDefendantName)
                                        let category = TagTypeString.string(from: tagType)
                                        dataViewModel.coreDataManager.lawsuitManager.editLawSuit(lawsuit: lawsuit, name: "\(lawsuitAuthorName) X \(lawsuitDefendantName)", number: lawsuitNumber, court: lawsuitCourt, category: category, defendantID: defendant.id, authorID: author.id, actionDate: lawsuitActionDate)
                                        
                                        //MARK: CloudKit - Editar
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
                                        //MARK: CoreData - Editar
                                        dataViewModel.coreDataManager.entityManager.editEntity(entity: author, name: lawsuitAuthorName)
                                        let category = TagTypeString.string(from: tagType)
                                        dataViewModel.coreDataManager.lawsuitManager.editLawSuit(lawsuit: lawsuit, name: "\(lawsuitAuthorName) X \(lawsuitDefendantName)", number: lawsuitNumber, court: lawsuitCourt, category: category, defendantID: defendant.id, authorID: author.id, actionDate: lawsuitActionDate)
                                        
                                        //MARK: CloudKit - Editar
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
                        
                    }, label: {
                        Text("Salvar")
                    })
                    .buttonStyle(.borderedProminent)
                    .alert(item: $invalidInformation) { error in
                        switch error {
                        case .missingInformation:
                            return Alert(title: Text("Informações Faltando"),
                                         message: Text("Por favor, preencha todos os campos antes de continuar."),
                                         dismissButton: .default(Text("Ok")))
                        case .invalidCPF:
                            return Alert(title: Text("CPF inválido"),
                                         message: Text("Por favor, insira um CPF válido antes de continuar."),
                                         dismissButton: .default(Text("Ok")))
                            
                        case .invalidRG:
                            return Alert(title: Text("RG inválido"),
                                         message: Text("Por favor, insira um RG válido antes de continuar"),
                                         dismissButton: .default(Text("Ok")))
                        case .invalidEmail:
                            return Alert(title: Text("E-mail inválido"),
                                         message: Text("Por favor, insira um e-mail válido antes de continuar"),
                                         dismissButton: .default(Text("Ok")))
                        case .missingTelephoneNumber:
                            return Alert(title: Text("Número de telefone inválido"),
                                         message: Text("Por favor, insira um número de telefone válido antes de continuar"),
                                         dismissButton: .default(Text("Ok")))
                        case .missingCellphoneNumber:
                            return Alert(title: Text("Número de celular inválido"),
                                         message: Text("Por favor, insira um número de celular válido antes de continuar"),
                                         dismissButton: .default(Text("Ok")))
                        case .invalidLawSuitNumber:
                            return Alert(title: Text("Número do processo inválido"),
                                         message: Text("Por favor, insira um número de processo válido antes de continuar"),
                                         dismissButton: .default(Text("Ok")))
                        }
                    }
                }
            }
        }
        .frame(minHeight: 255)
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
    func areFieldsFilled() -> Bool {
        return !lawsuitAuthorName.isEmpty &&
        !lawsuitCourt.isEmpty &&
        !lawsuitNumber.isEmpty &&
        !lawsuitActionDate.description.isEmpty &&
        !lawsuitDefendantName.isEmpty
    }
}
