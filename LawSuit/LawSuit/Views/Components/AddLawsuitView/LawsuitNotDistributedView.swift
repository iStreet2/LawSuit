//
//  ProcessNotDistributedView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 27/08/24.
//

import SwiftUI
import Combine

struct LawsuitNotDistributedView: View {
    
    //MARK: Variáveis de ambiente
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var textFieldDataViewModel: TextFieldDataViewModel
    
    //MARK: Variáveis de estado
    @State var missingInformation = false
    @State var selectTag = false
    @State var tagType: TagType = .civel
    @State var attributedAuthor = false
    @Binding var lawsuitNumber: String
    @Binding var lawsuitCourt: String
    @Binding var lawsuitAuthorName: String
    @Binding var lawsuitDefendantName: String
    @Binding var lawsuitActionDate: String
    @State var authorRowState: ClientRowStateEnum = .notSelected
    let textLimit = 100
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var lawyers: FetchedResults<Lawyer>
    
    var body: some View {
            VStack(alignment: .leading) {
                Text("Área")
                    .bold()
                TagViewPickerComponent(tagType: $tagType, tagViewStyle: .picker)
                HStack(alignment: .top, spacing: 70) {
                    VStack(alignment: .leading) {
                        EditLawsuitAuthorComponent(button: "Atribuir cliente", label: "Autor", lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, authorOrDefendant: "author", attributedAuthor: $attributedAuthor, attributedDefendant: .constant(false))
                        
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
                    LabeledTextField(label: "Réu", placeholder: "Adicionar réu ", textfieldText: $lawsuitDefendantName)
                        .onReceive(Just(lawsuitDefendantName)) { _ in textFieldDataViewModel.limitText(text: &lawsuitDefendantName, upper: textLimit) }
                }
              
            }
        Spacer()
    }
}
