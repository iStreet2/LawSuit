//
//  RequestDocumentsView.swift
//  LawSuit
//
//  Created by Giovanna Micher on 25/09/24.
//

import SwiftUI

struct RequestDocumentsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var client: Client
    @State var isRgOn: Bool = false
    @State var isCPFOn: Bool = false
    @State var isCNHOn: Bool = false
    @State var isCertidaoNascimentoOn: Bool = false
    @State var isCertidaoCasamentoOn: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Solicitar documentos")
                .font(.title)
                .bold()
            
            Text("Cliente: \(client.name)")
                .font(.title2)
            
            HStack(spacing: 50) {
                CheckboxIconComponent(isChecked: isRgOn, text: "RG")
                CheckboxIconComponent(isChecked: isCPFOn,text: "CPF")
                CheckboxIconComponent(isChecked: isCNHOn,text: "CNH")
                CheckboxIconComponent(isChecked: isCertidaoNascimentoOn,text: "Certidão de Nascimento")
            }
            CheckboxIconComponent(isChecked: isCertidaoCasamentoOn,text: "Certidão de Casamento")
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancelar")
                })
                Button(action: {
                    print(isRgOn)
                    print(isCPFOn)
                    print(isCNHOn)
                    print(isCertidaoNascimentoOn)
                    print(isCertidaoCasamentoOn)
                }, label: {
                    Text("Solicitar")
                })
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(width: 450, height: 200)
        .padding(20)
    }
}
