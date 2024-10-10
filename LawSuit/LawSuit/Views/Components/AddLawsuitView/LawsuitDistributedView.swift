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
        VStack{
            HStack{
                LabeledTextField(label: "Nº do processo", placeholder: "Nº do processo", textfieldText: $lawsuitNumber)
                    .onReceive(Just(lawsuitNumber)) { _ in lawsuitNumber = textFieldDataViewModel.lawSuitNumberValidation(lawsuitNumber)
                    }
                LabeledTextField(label: "Data de distribuição", placeholder: "Data de distribuição", textfieldText: $lawsuitActionDate)
                    .onReceive(Just(lawsuitActionDate)) { newValue in lawsuitActionDate = textFieldDataViewModel.dateValidation(newValue)}
                    .frame(width: 140)
            }
            
            HStack{
                VStack(alignment: .leading){
                    Text("Área")
                        .bold()
                    TagViewPickerComponent(tagType: $tagType, tagViewStyle: .picker)
                }
                LabeledTextField(label: "Vara", placeholder: "Vara", textfieldText: $lawsuitCourt)
            }
            
            HStack(alignment: .top){
                VStack(alignment: .leading){
                    //MARK: Caso usuário não selecionou nada ainda
                    if !attributedDefendant {
                        EditLawsuitAuthorComponent(button: "Atribuir Cliente", label: "Autor", lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, authorOrDefendant: "author", attributedAuthor: $attributedAuthor, attributedDefendant: $attributedDefendant)
                        
                    }
                    //MARK: Caso usuário atribuir cliente para o réu
                    if attributedDefendant {
                        LabeledTextField(label: "Autor", placeholder: "Adicionar Autor", textfieldText: $lawsuitAuthorName)
                            .onReceive(Just(lawsuitAuthorName)) { _ in textFieldDataViewModel.limitText(text: &lawsuitAuthorName, upper: textLimit) }
                    } else {
                        ClientRowSelectView(clientRowState: $authorRowState, lawsuitAuthorName: $lawsuitAuthorName)
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
                        EditLawsuitAuthorComponent(button: "Atribuir cliente", label: "Réu", lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, authorOrDefendant: "defendant", attributedAuthor: $attributedAuthor, attributedDefendant: $attributedDefendant)

                    }
                    //MARK: Caso o usuário tenha adicionado um cliente no autor
                    if attributedAuthor {
                        LabeledTextField(label: "Réu", placeholder: "Adicionar réu", textfieldText: $lawsuitDefendantName)
                            .onReceive(Just(lawsuitDefendantName)) { _ in textFieldDataViewModel.limitText(text: &lawsuitDefendantName, upper: textLimit) }
                        
                    } else {
                        ClientRowSelectView(clientRowState: $defendantRowState, lawsuitAuthorName: $lawsuitDefendantName)
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
            .background(Color("ScrollBackground"))
        }
    }
}

