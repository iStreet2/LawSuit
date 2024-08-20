//
//  OpenFilePDFView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//

import SwiftUI
import PDFKit

struct OpenFilePDFView: View {
    
    @Binding var selectedFile: FilePDF?
    
    var body: some View {
        if let selectedFile = selectedFile {
            if let content = selectedFile.content {
                if let filePDF = PDFDocument(data: content) {
                    PDFKitView(pdfDocument: filePDF)
                        .frame(minWidth: 500, minHeight: 600)
                } else {
                    Text("Erro ao criar o documento PDF")
                }
            } else {
                Text("Erro ao ler o conteudo")
            }
        } else {
            Text("Erro ao selecionar arquivo")
        }
    }
}
