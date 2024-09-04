//
//  OCRTestingView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 03/09/24.
//

import SwiftUI
import Vision
import PDFKit

struct PDFTextRecognitionView: View {
	
	@State private var recognizedTextWithBoxes: [(String, CGRect)] = []
	private var textRecognizer = TextRecognizer()
	private var pdfDocument: PDFDocument?
	
	let page = 0
	
	init() {
		if let url = Bundle.main.url(forResource: "Radiography Backend System - Paulo Sonzzini", withExtension: "pdf") {
			pdfDocument = PDFDocument(url: url)
		} else {
			print("not found")
		}
	}
	
	var body: some View {
		ZStack {
			if let pdfDocument = pdfDocument {
				PDFPageView(pdfPage: pdfDocument.page(at: page)!)
					.overlay(
						GeometryReader { geometry in
							ForEach(recognizedTextWithBoxes, id: \.0) { (_, boundingBox) in
								let rect = CGRect(
									x: boundingBox.origin.x * geometry.size.width,
									y: (1 - boundingBox.origin.y - boundingBox.size.height) * geometry.size.height,
									width: boundingBox.width * geometry.size.width,
									height: boundingBox.height * geometry.size.height
								)
								
								Rectangle()
									.stroke(Color.red, lineWidth: 2)
									.frame(width: rect.width, height: rect.height)
									.position(x: rect.midX, y: rect.midY)
							}
						}
					)
					.aspectRatio(contentMode: .fit)
			}
		}
		.padding()
		.frame(width: 900, height: 1000)
		.onAppear {
			Task {
				if let pdfDocument = pdfDocument {
					recognizedTextWithBoxes = await textRecognizer.recognizeTextWithBoundingBoxes(from: pdfDocument, pageIndex: page) ?? []
					
//					for page in 0..<pdfDocument.pageCount {
//						print(await textRecognizer.recognizeText(from: pdfDocument, pageIndex: page) ?? "NADIE")
//					}
					print(textRecognizer.PDFKITRecognizeText(from: pdfDocument).string)
				}
			}
		}
	}
}

struct PDFPageView: NSViewRepresentable {
	let pdfPage: PDFPage
	
	func makeNSView(context: Context) -> PDFView {
		let pdfView = PDFView()
		let pdfDocument = PDFDocument()
		pdfDocument.insert(pdfPage, at: 0)
		pdfView.document = pdfDocument
		pdfView.autoScales = true
		pdfView.displayMode = .singlePage
		return pdfView
	}
	
	func updateNSView(_ nsView: PDFView, context: Context) {
		//
	}
}

#Preview {
	PDFTextRecognitionView()
}
