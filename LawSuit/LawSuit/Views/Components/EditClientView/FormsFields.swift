//
//  FormsFields.swift
//  LawSuit
//
//  Created by Giovanna Micher on 23/08/24.
//

import SwiftUI

enum FormType {
    case personalInfo, address, contact, others
}

struct FormsFields: View {
    @State var formType: FormType
    @State var states = ["São Paulo", "Rio de Janeiro", "Mato Grosso do Sul", "Minas Gerais", "Rio Grande do Sul", "Acre", "Ceará"]
    @State var cities = ["São Paulo", "Mogi das Cruzes", "Maringá", "Iaras", "Osasco", "Carapicuíba", "Barueri"]
    
    
    init(formType: FormType = .personalInfo) {
        self.formType = formType
    }
    
    var body: some View {
        
        if formType == .personalInfo {
            HStack(alignment: .top) {
                VStack(spacing: 10) {
//                    LabeledTextField(label: "RG", placeholder: "RG", textfieldText: )
//                    LabeledField(label: "RG", placeholder: "Número do RG")
//                    LabeledField(label: "Filiação", placeholder: "Filiação")
//                    LabeledField(label: "Nacionalidade", placeholder: "Nacionalidade")
                }
                VStack(spacing: 10) {
//                    LabeledField(label: "CPF", placeholder: "Número do CPF")
//                    LabeledField(label: "Estado Civil", placeholder: "Estado Civil")
                }
            }
            .padding(.vertical, 5)
            
        } else if formType == .address {
            VStack(spacing: 10) {
                HStack(alignment: .top) {
//                    LabeledField(label: "CEP", placeholder: "Número do CEP")
//                    LabeledField(label: "Endereço", placeholder: "Endereço")
                }
                HStack(alignment: .top) {
//                    LabeledField(label: "Número", placeholder: "Número")
//                    LabeledField(label: "Bairro", placeholder: "Bairro")
//                    LabeledField(label: "Complemento", placeholder: "Complemento")
                }
                HStack(alignment: .top) {
//                    LabeledField(label: "Estado", placeholder: "", labeledFieldType: .picker, arrayInfo: states)
//                    LabeledField(label: "Cidade", placeholder: "", labeledFieldType: .picker, arrayInfo: cities)
                }
            }
  
        }

    }
}

#Preview {
    FormsFields(formType: .address)
}
