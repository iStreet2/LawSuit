//
//  MailManager.swift
//  LawSuit
//
//  Created by Giovanna Micher on 06/09/24.
//

import Foundation
import AppKit

class MailManager {
    
    private var client: Client
    
    init(client: Client) {
        self.client = client
    }

    func showMailComposer() {
        let service = NSSharingService(named: NSSharingService.Name.composeEmail)
        service?.recipients = [client.email]
        service?.subject = "Arqion: Aviso de movimentação de processo"
        service?.perform(withItems: ["Test Mail body"])
    }
  
//    func makeEmailBody() -> String {
//        //
//    }
}
