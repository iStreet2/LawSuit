//
//  MailMessageEnum.swift
//  LawSuit
//
//  Created by Giovanna Micher on 26/09/24.
//

import Foundation

enum MailMessageEnum: String {
    case requestDocumentsMessage
        
    func returnRequestDocumentsMessage(documents: [String], client: Client) -> String {
        let documentsList = documents.map { "<li>\($0)</li>" }.joined()
        let message = """
                        <html>
                            <head>
                                <meta charset="UTF-8">
                            </head>
                            <body>
                                <h1>Olá \(client.socialName ?? client.name)! Como você está?</h1>
                                <p>Para continuarmos o andamento do seu processo, preciso que envie os seguintes documentos:</p>
                                <ul>
                                    \(documentsList)
                                </ul>
                            </body>
                        </html>
                      """
        
        return message
    }
//    
//    func makeRequestDocumentsList(documents: [String]) -> String {
//        var returnedString = ""
//        
//        for document in documents {
//            returnedString.append("<li>")
//            returnedString.append(document)
//            returnedString.append("</li>")
//        }
//        print(returnedString)
//        return returnedString
//    }
}
