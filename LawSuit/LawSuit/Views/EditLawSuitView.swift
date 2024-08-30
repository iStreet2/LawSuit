//
//  EditLawSuitView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 30/08/24.
//

import SwiftUI

struct EditLawSuitView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var lawsuit: ProcessMock
    @State var date = "10/12/24"
    @State private var lawsuitTemp: ProcessMock
    //    @ObservedObject var client: Client
    
    init(lawsuit: Binding<ProcessMock>) {
        self._lawsuit = lawsuit
        self._lawsuitTemp = State(initialValue: lawsuit.wrappedValue)
    }
    
    var body: some View {
        VStack {
            LabeledTextField(label: "Nº do Processo", placeholder: "sei la", textfieldText: $lawsuitTemp.number)
            LabeledTextField(label: "Vara", placeholder: "sei la", textfieldText: $lawsuitTemp.court)
            HStack(alignment: .top, spacing: 70) {
                VStack {
                    EditProcessAuthorComponent(button: "Alterar Cliente", label: "Autor", screen: .small, lawsuit: $lawsuitTemp, defendantOrClient: "client")
                    TextField("", text: $lawsuitTemp.client.name)
                }
                Spacer()
                VStack(alignment: .leading) {
                    EditProcessAuthorComponent(button: "Atribuir Cliente", label: "Réu", screen: .small, lawsuit: $lawsuitTemp, defendantOrClient: "defendant")
                    TextField("", text: $lawsuitTemp.defendant)
                    LabeledDateField(selectedDate: $lawsuit.actionDate, label: "Data da distribuição")
                    HStack {
                        Spacer()
                        Button(action: {
                            //resetar os valores
                            dismiss()
                        }, label: {
                            Text("Cancelar")
                        })
                        Button(action: {
                            lawsuit.number = lawsuitTemp.number
                            lawsuit.court = lawsuitTemp.court
                            lawsuit.client = lawsuitTemp.client
                            lawsuit.defendant = lawsuitTemp.defendant
                            dismiss()
                        }, label: {
                            Text("Salvar")
                        })
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.top)
                }
            }
        }
        .padding()
    }
}
