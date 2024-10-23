//
//  PDFViewModel.swift
//  LawSuit
//
//  Created by Giovanna Micher on 22/10/24.
//

import Foundation
import PDFKit
import UniformTypeIdentifiers

class PDFViewModel: ObservableObject {
    @Published var name = ""
    @Published var cpf = ""
    @Published var birthDate = ""
    @Published var affiliation = ""
    @Published var telephone = ""
    @Published var email = ""
    
    func loadDocument(pdfURL: URL) {
        if let pdfDocument = PDFDocument(url: pdfURL) {
            extractInfoFromPDF(pdfDocument: pdfDocument)
        }
    }
    
    func getPDFurl(completion: @escaping (URL?) -> Void) {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [UTType.pdf]
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        
        openPanel.begin { response in
            if response == .OK, let url = openPanel.url {
                completion(url)
            } else {
                completion(nil)
            }
        }
    }
    
    func extractInfoFromPDF(pdfDocument: PDFDocument) {
        guard let page = pdfDocument.page(at: 0) else { return }
        let pdfText = page.string ?? ""
        
        //Nome
        if let extractedName = extractDataFromPDF(text: pdfText, pattern: "Nome\\s*([A-Za-z ]+)") {
            name = extractedName
            print(extractedName)
        }
        
        //CPF
        if let extractedCPF = extractDataFromPDF(text: pdfText, pattern: "CPF\\s*([0-9]{3}\\.[0-9]{3}\\.[0-9]{3}-[0-9]{2})") {
            cpf = extractedCPF
            print(extractedCPF)
        }
        
        //Data de nascimento
        if let extractedBirthDate = extractDataFromPDF(text: pdfText, pattern: "\\s*([0-9]{2}/[0-9]{2}/[0-9]{4})") {
            birthDate = extractedBirthDate
            print(extractedBirthDate)
        }
        
        //Filiação
        if let extractedAffiliation = extractDataFromPDF(text: pdfText, pattern: "Mãe\\s*([A-Za-z ]+)") {
            affiliation = extractedAffiliation
            print(affiliation)
        }
        
        //Telefone
        if let extractedTelephone = extractDataFromPDF(text: pdfText, pattern: "Telefone\\s*([()0-9\\s-]+)") {
            telephone = extractedTelephone
            print(telephone)
        }
        
        //Email
        if let extractedEmail = extractDataFromPDF(text: pdfText, pattern: "E-mail\\s*([A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,})") {
            email = extractedEmail
            print(email)
        }
    }
    
    func extractDataFromPDF(text: String, pattern: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let nsString = text as NSString
        let results = regex?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
        if let range = results?.range(at: 1) {
            return nsString.substring(with: range)
        }
        return nil
    }
}
