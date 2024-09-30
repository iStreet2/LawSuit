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

    func sendMail(emailSubject: String, message: String) {
        let service = NSSharingService(named: .composeEmail)
        service?.recipients = [client.email]
        service?.subject = emailSubject
        
        //convert String to NSAttributedString
        let data = message.data(using: .utf8)
        if let data = data {
            let attributedString = NSAttributedString(html: data, documentAttributes: nil)
            service?.perform(withItems: [attributedString as Any])
        }
    }

}
