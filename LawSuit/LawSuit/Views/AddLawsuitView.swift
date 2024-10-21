//
//  NewProcessView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 23/08/24.
//

import SwiftUI
import CoreData

//enum LawsuitType: String {
//    case distributed = "Distribuído"
//    case notDistributed = "Não Distribuído"
//}

struct AddLawsuitView: View {
    
    //MARK: Variáveis de ambiente
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataViewModel: DataViewModel
    @EnvironmentObject var lawsuitViewModel: LawsuitViewModel
    @EnvironmentObject var textFieldDataViewModel: TextFieldDataViewModel
    
    //MARK: Variáveis de estado
    @State var isDistributed: Bool = true
    @State var lawsuitTypeString: String = ""
    
    @State var lawsuitNumber = ""
    @State var lawsuitCourt = ""

    @State var lawsuitAuthorName = ""
    @State var lawsuitDefendantName = ""

    @State var lawsuitActionDate = ""
    @State var invalidInformation: InvalidInformation?
    @State var tagType: TagType = .civel

    @State var attributedAuthor = false
    @State var attributedDefendant = false
    
    //MARK: CoreData
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var lawyers: FetchedResults<Lawyer>

    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                Text("Novo Processo")
                    .bold()
                    .font(.title)
                    CustomSegmentedControl(
                        selectedOption: $lawsuitTypeString, infos: ["Distribuído","Não Distribuído"])
            }
            .padding(10)
            Divider()
                .frame(maxWidth: .infinity)

            VStack(spacing: 0) {
                if isDistributed {
                    LawsuitDistributedView(tagType: $tagType, lawsuitNumber: $lawsuitNumber, lawsuitCourt: $lawsuitCourt, lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, lawsuitActionDate: $lawsuitActionDate, attributedAuthor: $attributedAuthor, attributedDefendant: $attributedDefendant)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    LawsuitNotDistributedView(tagType: $tagType, lawsuitNumber: $lawsuitNumber, lawsuitCourt: $lawsuitCourt, lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, lawsuitActionDate: $lawsuitActionDate, attributedAuthor: $attributedAuthor, attributedDefendant: $attributedDefendant)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding(.horizontal, 10)
            .background(Color("ScrollBackground"))

            Divider()
                .frame(maxWidth: .infinity)
        }
        .frame(width: 510, height: 350)
        .onAppear {
            lawsuitTypeString = "Distribuído"
        }
        .onChange(of: lawsuitTypeString) { oldValue, newValue in
            if newValue == "Distribuído" {
                isDistributed = true
            } else {
                isDistributed = false
            }
        }

        HStack {
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Cancelar")
            }
            Button {
                
                if isDistributed {
                    if !areDistributedFieldsFilled() {
                        invalidInformation = .missingInformation
                        return
                    }
                    if lawsuitNumber.count < 25 {
                        invalidInformation = .invalidLawSuitNumber
                        return
                    }
                } else {
                    if !areNotDistributedFieldsFilled() {
                        invalidInformation = .missingInformation
                        return
                    }
                }
                if textFieldDataViewModel.dateValidation(lawsuitActionDate) {
                    invalidInformation = .invalidDate
                    return
                }
                //MARK: Se o cliente foi atribuido ao autor
                if attributedAuthor {
                    if let author = dataViewModel.coreDataManager.clientManager.fetchFromName(name: lawsuitAuthorName) {
                        let category = tagType.tagText
                        let lawyer = lawyers[0]
                        let defendant = dataViewModel.coreDataManager.entityManager.createAndReturnEntity(name: lawsuitDefendantName)
                        let lawsuit = dataViewModel.coreDataManager.lawsuitManager.createLawsuit(authorName: lawsuitAuthorName, defendantName: lawsuitDefendantName, number: lawsuitNumber, court: lawsuitCourt, category: category, lawyer: lawyer, defendantID: defendant.id, authorID: author.id, actionDate: lawsuitActionDate.convertBirthDateToDate(), isDistributed: isDistributed)
                                                
                        if lawsuit.isDistributed {
                            dataViewModel.coreDataManager.lawsuitNetworkingViewModel.fetchAndSaveUpdatesFromAPI(fromLawsuit: lawsuit)
                        }

                        dismiss()
                    } else {
                        print("Client not found")
                    }
                }
                //MARK: Se o cliente foi atribuido ao réu
                else if attributedDefendant {
                    if let defendant = dataViewModel.coreDataManager.clientManager.fetchFromName(name: lawsuitDefendantName) {
                        let category = tagType.tagText
                        let lawyer = lawyers[0]
                        let author = dataViewModel.coreDataManager.entityManager.createAndReturnEntity(name: lawsuitAuthorName)
                        let lawsuit = dataViewModel.coreDataManager.lawsuitManager.createLawsuit(authorName: lawsuitAuthorName, defendantName: lawsuitDefendantName, number: lawsuitNumber, court: lawsuitCourt, category: category, lawyer: lawyer, defendantID: defendant.id, authorID: author.id, actionDate: lawsuitActionDate.convertBirthDateToDate(), isDistributed: isDistributed)                        
                        
                        if lawsuit.isDistributed {
                            dataViewModel.coreDataManager.lawsuitNetworkingViewModel.fetchAndSaveUpdatesFromAPI(fromLawsuit: lawsuit)
                        }

                        dismiss()
                    } else {
                        print("Client not found")
                    }
                }
            } label: {
                Text("Criar")
            }
            .buttonStyle(.borderedProminent)
            .tint(.black)
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
                    message: Text("Por favor, insira um número de CEP válido antes de continuar"),
                    dismissButton: .default(Text("Ok")))
                    
                case .invalidDate:
                    return Alert(title: Text("Data de distribuição inválida"),
                                 message: Text("Por favor, insira uma data válida antes de continuar"),
                                 dismissButton: .default(Text("Ok")))
                }
            }
            
        }
        .padding( 10)
     
    }
    
    func areDistributedFieldsFilled() -> Bool {
        return !lawsuitNumber.isEmpty &&
        !lawsuitCourt.isEmpty &&
        !lawsuitActionDate.description.isEmpty &&
        !lawsuitAuthorName.isEmpty &&
        !lawsuitDefendantName.isEmpty
    }
    
    func areNotDistributedFieldsFilled() -> Bool {
        return !lawsuitAuthorName.isEmpty &&
        !lawsuitDefendantName.isEmpty
    }
}
