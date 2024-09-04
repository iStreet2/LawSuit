//
//  TextRecognizer.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 03/09/24.
//

import Vision
import PDFKit
import CoreGraphics

class TextRecognizer {
	
	// MARK: Renderiza as boundingBoxes em uma PDFView
	func recognizeTextWithBoundingBoxes(from pdfDocument: PDFDocument, pageIndex: Int) async -> [(String, CGRect)]? {
		guard let page = pdfDocument.page(at: pageIndex) else {
			return nil
		}
		
		let pdfPageBounds = page.bounds(for: .mediaBox)
		let pageImage = page.thumbnail(of: pdfPageBounds.size, for: .mediaBox)
		
		guard let cgImage = pageImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
			return nil
		}
		
		let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
		let textRecognitionRequest = VNRecognizeTextRequest()
		textRecognitionRequest.recognitionLevel = .accurate
		
		do {
			try requestHandler.perform([textRecognitionRequest])
			guard let observations = textRecognitionRequest.results else {
				return nil
			}
			
			let recognizedTexts: [(String, CGRect)] = observations.compactMap { observation in
				guard let topCandidate = observation.topCandidates(1).first else { return nil }
				let boundingBox = observation.boundingBox
				return (topCandidate.string, boundingBox)
			}
			
			return recognizedTexts
		} catch {
			print("Error recognizing text: \(error)")
			return nil
		}
	}
	
	// MARK: Devolve o texto reconhecido
	func recognizeText(from pdfDocument: PDFDocument, pageIndex: Int) async -> String? {
		guard let page = pdfDocument.page(at: pageIndex) else {
			return nil
		}
		
		let pdfPageBounds = page.bounds(for: .mediaBox)
		let pageImage = page.thumbnail(of: pdfPageBounds.size, for: .mediaBox)
		
		guard let cgImage = pageImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
			return nil
		}
		
		let requestHandler = VNImageRequestHandler(cgImage: cgImage)
		let textRecognitionRequest = VNRecognizeTextRequest()
		textRecognitionRequest.recognitionLevel = .accurate
		
		do {
			try requestHandler.perform([textRecognitionRequest])
			guard let observations = textRecognitionRequest.results else {
				return nil
			}
			
			let recognizedText = observations.compactMap { observation in
				observation.topCandidates(1).first?.string
			}.joined(separator: " ")
			
			return recognizedText
		} catch {
			print("Error recognizing text: \(error)")
			return nil
		}
	}
	
	// MARK: Devolve TUDO encontrado no documento PDF, separado por página :thumbsup:
	func recognizeAllText(from pdfDocument: PDFDocument) async -> [String]? {
		var texts: [String] = []
		
		for page in 0..<pdfDocument.pageCount {
			guard let currentPage = pdfDocument.page(at: page) else { return nil }
			
			let pdfPageBounds = currentPage.bounds(for: .mediaBox)
			let pageImage = currentPage.thumbnail(of: pdfPageBounds.size, for: .mediaBox)
			
			guard let cgImage = pageImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
			
			let requestHandler = VNImageRequestHandler(cgImage: cgImage)
			let textRecognitionRequest = VNRecognizeTextRequest()
			textRecognitionRequest.recognitionLevel = .accurate
			
			do {
				try requestHandler.perform([textRecognitionRequest])
				guard let observations = textRecognitionRequest.results else { return nil }
				
				let recognizedText = observations.compactMap { observation in
					observation.topCandidates(1).first?.string
				}.joined(separator: " ")
				
				texts.append(recognizedText)
			} catch {
				print("Error recognizing text: \(error)")
				return nil
			}
		}
		
		return texts
	}
	
	func PDFKITRecognizeText(from pdfDocument: PDFDocument) -> NSMutableAttributedString {
//		var texts: [String] = []
		
		let pageCount = pdfDocument.pageCount
		let documentContent = NSMutableAttributedString()
		
		for i in 0 ..< pageCount {
			guard let page = pdfDocument.page(at: i) else { continue }
			guard let pageContent = page.attributedString else { continue }
			documentContent.append(pageContent)
		}
		
		return documentContent
	}
}
