//
//  SendMailSheet.swift
//  LawSuit
//
//  Created by Giovanna Micher on 10/10/24.
//

import SwiftUI

struct SendMailSheet: View {
    @Environment(\.dismiss) var dismiss
    var mailManager: MailManager
    @Binding var doNotShowAgain: Bool
    
    var body: some View {
        VStack {
            Text("Certifique-se de que sua preferência de e-mail é um provedor válido (Mail -> Ajustes -> Geral -> App de e-mail padrão). Isso garantirá que o envio de mensagens ocorra corretamente")
                .font(.footnote)
            Spacer()
            HStack {
                Spacer()
                
                Toggle(isOn: $doNotShowAgain) {
                    Text("Não mostrar isso novamente")
                }
                .toggleStyle(.checkbox)
                .tint(.black)
                
                Button {
                    UserDefaults.standard.set(doNotShowAgain, forKey: "DoNotShowAgainPreference")
                    dismiss()
                    print("toggle: \(doNotShowAgain)")
                    mailManager.sendMail(emailSubject: "Arqion", message: "")
                } label: {
                    Text("Ok")
                }
                .buttonStyle(.borderedProminent)
                .tint(.black)
            }
        }
        .padding()
    }
}

