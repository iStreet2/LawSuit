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
    
    init(formType: FormType = .personalInfo) {
        self.formType = formType
    }
    
    var body: some View {
        
        if formType == .personalInfo {
            HStack(alignment: .top) {
                VStack(spacing: 10) {
                    LabeledField(label: "RG", placeholder: "Número do RG")
                    LabeledField(label: "Filiação", placeholder: "Filiação")
                    LabeledField(label: "Nacionalidade", placeholder: "Nacionalidade")
                }
                VStack(spacing: 10) {
                    LabeledField(label: "CPF", placeholder: "Número do CPF")
                    LabeledField(label: "Estado Civil", placeholder: "Estado Civil")
                }
            }
            .padding(.vertical, 5)
            
        } else if formType == .address {
            VStack {
                HStack(alignment: .top) {
                    LabeledField(label: "CEP", placeholder: "Número do CEP")
                    LabeledField(label: "Endereço", placeholder: "Endereço")
                }
                HStack {
                    LabeledField(label: "Nacionalidade", placeholder: "Nacionalidade")

                }
            }

            
        }
        
        
    }
}

#Preview {
    FormsFields(formType: .address)
}
