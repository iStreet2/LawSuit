//
//  NewProcessView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 23/08/24.
//

import SwiftUI

struct NewProcessView: View {
    
    @State var textInput = ""
    @State private var birthDate = Date.now
    @State private var selectedOption: String = "Distribuído"
    
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Novo Processo")
                .bold()
                .font(.title)
            
            VStack(alignment: .leading) {
                SegmentedControlComponent(
                    selectedOption: $selectedOption,
                    infos: ["Distribuído", "Não Distribuído"]                )
                .frame(width: 150)
            }
            .padding()
            
            Text("Nº do processo")
                .bold()
            TextField("Nº do processo", text: $textInput)
                .textFieldStyle(.roundedBorder)
            
            
            Text("Vara")
                .bold()
            TextField("Vara", text: $textInput)
                .textFieldStyle(.roundedBorder)
            
            
            
            HStack {
                VStack(alignment: .leading){
                    EditProcessAuthorComponent()
                    Text("Área")
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .leading){
                    HStack {
                        Text("Réu ")
                            .bold()
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("Atribuir Cliente")
                        })
                        .buttonStyle(.borderless)
                        .foregroundStyle(.blue)
                    }
                    
                    TextField("Réu", text: $textInput)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                    
                    Text("Data de distribuição ")
                        .bold()
                    DatePicker(selection: $birthDate, in: ...Date.now, displayedComponents: .date) { }
                        .datePickerStyle(.field)
                }
                
            }
            HStack {
                
                Spacer()
                
                Button {
                } label: {
                    Text("Cancelar")
                }
                Button {
                    
                } label: {
                    Text("Próximo")
                }
                .buttonStyle(.borderedProminent)
                
            }
            
        }        .padding(100)
        
    }
}

#Preview {
    NewProcessView()
}
