//
//  PDFKitView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//

import Foundation
import SwiftUI
import PDFKit

struct PDFKitView: NSViewRepresentable {
    var pdfDocument: PDFDocument
    
    func makeNSView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateNSView(_ nsView: PDFView, context: Context) {
        nsView.document = pdfDocument
    }
}
