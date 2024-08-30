//
//  CheckboxView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 15/08/24.
//

import SwiftUI

struct CheckboxView: View {
    
    @State var choosedClient: String = ""
    @State var files = ["RG", "CPF"]
    var cliente: ClientCheckboxIconComponent
    var screen: SizeEnumerator
    @Binding var lawsuit: ProcessMock
    @State var seiLa: String = ""

    
    var body: some View {
        
        VStack(alignment: .leading){
            Text("Solicitar documentos")
                .font(.title)
                .bold()
            
            
            Text("Ciente: \(choosedClient)")
                .font(.title3)
                .bold()
            
            ClientCheckboxIconComponent(lawsuit: $lawsuit, choosedClient: $choosedClient, screen: .big, defendantOrClient: $seiLa)
            
            Text("Documentos:")
                .font(.title3)
                .bold()
            
            HStack{
                ForEach(files, id: \.self) {file in
                    CheckboxIconComponent(files: file)

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
                    Text("Solicitar")
                }
                .buttonStyle(.borderedProminent)

        }
        }
        .frame(width: 500)
        .padding(15)
        .background(.white)

    }
}

