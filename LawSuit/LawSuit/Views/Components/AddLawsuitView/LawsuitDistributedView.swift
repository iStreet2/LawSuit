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
    @EnvironmentObject var textFieldDataViewModel: TextFieldDataViewModel
    @EnvironmentObject var lawsuitViewModel: LawsuitViewModel
    
    @State var textInput = ""
    @Binding var tagType: TagType
    @State var selectTag = false
    @State var birthDateString: String = ""
    @State var showError: Bool = false
    
    //MARK: Variáveis de estado
    @State var authorRowState: ClientRowStateEnum = .notSelected
    @State var defendantRowState: ClientRowStateEnum = .notSelected
    @State var invalidInformation: LawsuitInvalidInformation?
    @Binding var lawsuitNumber: String
    @Binding var lawsuitCourt: String
    @Binding var lawsuitAuthorName: String
    @Binding var lawsuitDefendantName: String
    @Binding var lawsuitActionDate: String
    @EnvironmentObject var dataViewModel: DataViewModel
    
    @Binding var attributedAuthor: Bool
    @Binding var attributedDefendant: Bool
    
    let textLimit = 50
    
    //MARK: CoreData
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var lawyers: FetchedResults<Lawyer>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                    LabeledTextField(label: "Nº do processo", placeholder: "Nº do processo", mandatory: true, textfieldText: $lawsuitNumber)
                        .onReceive(Just(lawsuitNumber)) { _ in lawsuitNumber = textFieldDataViewModel.lawSuitNumberValidation(lawsuitNumber)
                        
                }
                VStack(alignment: .leading, spacing: 10) {
                    LabeledTextField(label: "Data de distribuição", placeholder: "Data de distribuição", mandatory: true, textfieldText: $lawsuitActionDate)
                        .onReceive(Just(lawsuitActionDate)) { newValue in lawsuitActionDate = textFieldDataViewModel.dateFormat(newValue)}
                        .onChange(of: lawsuitActionDate) { newValue in
                            if lawsuitActionDate.count == 10 {
                                showError = textFieldDataViewModel.dateValidation(lawsuitActionDate)
                            } else {
                                showError = false
                            }
                        }
                    if showError {
                        Text("Data inválida")
                            .foregroundColor(.red)
                            .font(.callout)
                    } else {
                        Text(" ") 
                            .font(.callout)
                    }
                }
                .frame(width: 140)
            }
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    HStack(alignment: .top, spacing: 1) {
                        Text("Área")
                            .bold()
                        Text("*")
                            .foregroundStyle(.wine)
                    }
                    TagViewPickerComponent(tagType: $tagType, tagViewStyle: .picker)
                }
                Spacer()
                
                LabeledTextField(label: "Vara", placeholder: "Vara", mandatory: true, textfieldText: $lawsuitCourt)
                    .padding(.vertical, 1) // Adiciona padding vertical para evitar bordas cortadas
                    .frame(width: 360)
            }
            
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    //MARK: Caso usuário não selecionou nada ainda
                    if !attributedDefendant {
                        EditLawsuitAuthorComponent(button: "Atribuir Cliente", label: "Autor", lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, authorOrDefendant: "author", attributedAuthor: $attributedAuthor, attributedDefendant: $attributedDefendant, required: true)
                    }
                    //MARK: Caso usuário atribuir cliente para o réu
                    if attributedDefendant {
                        LabeledTextField(label: "Autor", placeholder: "Adicionar Autor", mandatory: true, textfieldText: $lawsuitAuthorName)
                            .frame(width: 218)
                            .onReceive(Just(lawsuitAuthorName)) { _ in textFieldDataViewModel.limitText(text: &lawsuitAuthorName, upper: textLimit) }
                    } else {
                        ClientRowSelectView(clientRowState: $authorRowState, lawsuitAuthorOrDefendantName: $lawsuitAuthorName)
                            .onChange(of: lawsuitAuthorName) { newValue in
                                if !newValue.isEmpty {
                                    authorRowState = .selected
                                } else {
                                    authorRowState = .notSelected
                                    attributedAuthor = false
                                }
                            }
                    }
                }
                Spacer()
                
                VStack(alignment: .leading){
                    //MARK: Se o usuário não selecionou nada
                    if !attributedAuthor {
                        EditLawsuitAuthorComponent(button: "Atribuir cliente", label: "Réu", lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, authorOrDefendant: "defendant", attributedAuthor: $attributedAuthor, attributedDefendant: $attributedDefendant, required: true)
                        
                    }
                    //MARK: Caso o usuário tenha adicionado um cliente no autor
                    if attributedAuthor {
                        LabeledTextField(label: "Réu", placeholder: "Adicionar réu", mandatory: true ,textfieldText: $lawsuitDefendantName)
                            .frame(width: 218)
                            .onReceive(Just(lawsuitDefendantName)) { _ in textFieldDataViewModel.limitText(text: &lawsuitDefendantName, upper: textLimit) }
                        
                        
                    } else {
                        ClientRowSelectView(clientRowState: $defendantRowState, lawsuitAuthorOrDefendantName: $lawsuitDefendantName)
                            .onChange(of: lawsuitDefendantName) { newValue in
                                if !newValue.isEmpty {
                                    defendantRowState = .selected
                                } else {
                                    defendantRowState = .notSelected
                                    attributedDefendant = false
                                }
                            }
                        
                    }
                }
            }
            .padding(.top)
            .background(Color("ScrollBackground"))
        }
    }
}
