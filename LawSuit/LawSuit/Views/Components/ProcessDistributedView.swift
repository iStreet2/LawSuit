//
//  ProcessDistributedView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 27/08/24.
//

import SwiftUI

struct ProcessDistributedView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var mockViewModel: MockViewModel
    
    @State var textInput = ""
    @State private var birthDate = Date.now
    @Binding var lawsuit: ProcessMock
    @State var clientMock: ClientMock
    @State var tagType: TagType = .trabalhista

    var body: some View {
    
        VStack{
            LabeledTextField(label: "Nº do processo", placeholder: "Nº do processo", textfieldText: $lawsuit.number)
        }
        VStack{
            LabeledTextField(label: "Vara", placeholder: "Vara", textfieldText: $lawsuit.court)
        }
        HStack(alignment: .top){
            VStack(alignment: .leading){
                EditProcessAuthorComponent(button: "Alterar cliente", label: "Autor", screen: .small, lawsuit: $lawsuit, defendantOrClient: "client")
                TextField("", text: $lawsuit.client.name)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 200)
//                Text("Área")
//                    .bold()
//                TagViewPickerComponentV5(currentTag: $tagType)
            }
            
            Spacer()
            
            VStack(alignment: .leading){
                VStack(alignment: .leading){
                    EditProcessAuthorComponent(button: "Atribuir cliente", label: "Réu", screen: .small, lawsuit: $lawsuit, defendantOrClient: "defendant")
                    TextField("", text: $lawsuit.defendant)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                }
               
                
                Text("Data de distribuição ")
                    .bold()
                DatePicker(selection: $birthDate, in: ...Date.now, displayedComponents: .date) { }
                    .datePickerStyle(.field)
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
                lawsuit.title = "Carlos Gomes Barbosa x Micher Autopeças"
                lawsuit.lastMovement = "Sem movimentações recentes"
                lawsuit.client = ClientMock()
                lawsuit.client.name = "Carlos Gomes Barbosa"
                lawsuit.lawyer = LawyerMock(name: "Gabriel Vicentin Negro")
                lawsuit.tagType = .trabalhista
                mockViewModel.processList.append(lawsuit)
                dismiss()
            } label: {
                Text("Criar")
            }
            .buttonStyle(.borderedProminent)
            
        }
        
    }
    
    
    
}
//
//#Preview {
//    @State var processMock = ProcessMock(processNumber: "1383984", court: "28382934", defendant: "")
//    @State var clientMock = ClientMock(name: "lala", occupation: "sjkcn", rg: "sjkcn", cpf: "sjkcn", affiliation: "sjkcn", maritalStatus: "sjkcn", nationality: "sjkcn", birthDate: Date(), cep: "sjkcn", address: "sjkcn", addressNumber: "sjkcn", neighborhood: "sjkcn", complement: "sjkcn", state: "sjkcn", city: "sjkcn", email: "sjkcn", telephone: "sjkcn", cellphone: "sjkcn")
//    return ProcessDistributedView(processMock: processMock, clientMock: clientMock)
//}
