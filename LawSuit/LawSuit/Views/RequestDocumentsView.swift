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
//    @State var isRgOn: Bool = false
//    @State var isCPFOn: Bool = false
//    @State var isCNHOn: Bool = false
//    @State var isCertidaoNascimentoOn: Bool = false
//    @State var isCertidaoCasamentoOn: Bool = false
//    
    @State var documents: [(name: String, isSelected: Bool)] = [
        ("RG", false),
        ("CPF", false),
        ("CNH", false),
        ("Certidão de Nascimento", false),
        ("Certidão de Casamento", false)
    ]
    
    var mailManager: MailManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Solicitar documentos")
                .font(.title)
                .bold()
            
            Text("Cliente: \(client.name)")
                .font(.title2)
            
            HStack(spacing: 50) {
                ForEach(0..<4) { index in
                    CheckboxIconComponent(isChecked: $documents[index].isSelected, text: documents[index].name)
                }
            }
            CheckboxIconComponent(isChecked: $documents[4].isSelected, text: documents[4].name)

            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancelar")
                })
                Button(action: {
                    mailManager.sendMail(
                        emailSubject: "Solicitação de documentos para seu processo",
                        message: MailMessageEnum.requestDocumentsMessage.returnRequestDocumentsMessage(documents: selectedDocuments(), client: client))
                }, label: {
                    Text("Solicitar")
                })
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(width: 450, height: 200)
        .padding(20)
    }
    
    func selectedDocuments() -> [String] {
        documents.filter { $0.isSelected }.map { $0.name }
    }
}
