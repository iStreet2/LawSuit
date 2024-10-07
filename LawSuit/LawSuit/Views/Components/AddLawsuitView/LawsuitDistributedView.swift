////
////  ProcessDistributedView.swift
////  LawSuit
////
////  Created by Emily Morimoto on 27/08/24.
////

import SwiftUI
import Combine

struct LawsuitDistributedView: View {
    
    //MARK: Variáveis de Ambiente
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var textFieldDataViewModel: TextFieldDataViewModel
    
    @State var textInput = ""
    @State var tagType: TagType = .civel
    @State var selectTag = false
    
    //MARK: Variáveis de estado
    @State var invalidInformation: InvalidInformation?
    @Binding var lawsuitNumber: String
    @Binding var lawsuitCourt: String
    @Binding var lawsuitAuthorName: String
    @Binding var lawsuitDefendantName: String
    @Binding var lawsuitActionDate: String
    @EnvironmentObject var dataViewModel: DataViewModel
    
    @State var attributedAuthor = false
    @State var attributedDefendant = false
    
    let textLimit = 50
    
    //MARK: CoreData
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var lawyers: FetchedResults<Lawyer>
    
    var body: some View {
        VStack{
            LabeledTextField(label: "Nº do processo", placeholder: "Nº do processo", textfieldText: $lawsuitNumber)
                .onReceive(Just(lawsuitNumber)) { _ in lawsuitNumber = textFieldDataViewModel.lawSuitNumberValidation(lawsuitNumber)
                }
            LabeledTextField(label: "Vara", placeholder: "Vara", textfieldText: $lawsuitCourt)
        }
        HStack(alignment: .top){
            VStack(alignment: .leading){
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
                .frame(width: 200, alignment: .leading)
                
                Text("Área")
                    .padding(.top)
                    .bold()
					TagViewPickerComponentV1(currentTag: $tagType)

            }
            Spacer()
            VStack(alignment: .leading){
                VStack(alignment: .leading){
                    //MARK: Se o usuário não selecionou nada
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
                        }
                    }
                    .frame(width: 200, alignment: .leading)
                }
                LabeledTextField(label: "Data de distribuição", placeholder: "", textfieldText: $lawsuitActionDate)
                    .onReceive(Just(lawsuitActionDate)) { newValue in lawsuitActionDate = textFieldDataViewModel.dateValidation(newValue)}
                    .padding(.top)
            }
        }
        Spacer()
        Spacer()
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("Cancelar")
            }
            Button {
                if !areFieldsFilled() {
                    invalidInformation = .missingInformation
                    return
                }
                if lawsuitNumber.count < 25 {
                    invalidInformation = .invalidLawSuitNumber
                    return
                }
                    //MARK: Se o cliente foi atribuido ao autor
                    if attributedAuthor {
                        if let author = dataViewModel.coreDataManager.clientManager.fetchFromName(name: lawsuitAuthorName) {
                            let category = TagTypeString.string(from: tagType)
                            let lawyer = lawyers[0]
                            let defendant = dataViewModel.coreDataManager.entityManager.createAndReturnEntity(name: lawsuitDefendantName)
                            let lawsuit = dataViewModel.coreDataManager.lawsuitManager.createLawsuit(name: "\(lawsuitAuthorName) X \(lawsuitDefendantName)", number: lawsuitNumber, court: lawsuitCourt, category: category, lawyer: lawyer, defendantID: defendant.id, authorID: author.id, actionDate: lawsuitActionDate.convertBirthDateToDate())

                            dataViewModel.coreDataManager.lawsuitNetworkingViewModel.fetchAndSaveUpdatesFromAPI(fromLawsuit: lawsuit)
                          
                            dismiss()
                        } else {
                            print("Client not found")
                        }
                    }
                    //MARK: Se o cliente foi atribuido ao réu
                    else if attributedDefendant {
                        if let defendant = dataViewModel.coreDataManager.clientManager.fetchFromName(name: lawsuitDefendantName) {
                            let category = TagTypeString.string(from: tagType)
                            let lawyer = lawyers[0]
                            let author = dataViewModel.coreDataManager.entityManager.createAndReturnEntity(name: lawsuitAuthorName)
                            let lawsuit = dataViewModel.coreDataManager.lawsuitManager.createLawsuit(name: "\(lawsuitAuthorName) X \(lawsuitDefendantName)", number: lawsuitNumber, court: lawsuitCourt, category: category, lawyer: lawyer, defendantID: defendant.id, authorID: author.id, actionDate: lawsuitActionDate.convertBirthDateToDate())
                        
                                dataViewModel.coreDataManager.lawsuitNetworkingViewModel.fetchAndSaveUpdatesFromAPI(fromLawsuit: lawsuit)
  
                            dismiss()
                        } else {
                            print("Client not found")
                        }
                    }
                
            } label: {
                Text("Criar")
            }
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
                case .missingCellphoneNumber:
                    return Alert(title: Text("Número de celular inválido"),
                                 message: Text("Por favor, insira um número de celular válido antes de continuar"),
                                 dismissButton: .default(Text("Ok")))
                case .invalidLawSuitNumber:
                    return Alert(title: Text("Número do processo inválido"),
                    message: Text("Por favor, insira um número de processo válido antes de continuar"),
                    dismissButton: .default(Text("Ok")))
                case .invalidCEP:
                    return Alert(title: Text("Número do processo inválido"),
                    message: Text("Por favor, insira um número de processo válido antes de continuar"),
                    dismissButton: .default(Text("Ok")))
                }
            }

        }
    }
    func areFieldsFilled() -> Bool {
        return !lawsuitNumber.isEmpty &&
        !lawsuitCourt.isEmpty &&
        !lawsuitActionDate.description.isEmpty &&
        !lawsuitAuthorName.isEmpty &&
        !lawsuitDefendantName.isEmpty
        
    }
}
