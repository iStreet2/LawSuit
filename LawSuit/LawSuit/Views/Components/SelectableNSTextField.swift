//
//  SelectableNSTextField.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 16/10/24.
//


import SwiftUI
import AppKit

struct SelectableNSTextField: NSViewRepresentable {
    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: SelectableNSTextField

        init(_ parent: SelectableNSTextField) {
            self.parent = parent
        }

        func controlTextDidChange(_ obj: Notification) {
            if let textField = obj.object as? NSTextField {
                parent.text = textField.stringValue
            }
        }
    }

    @Binding var text: String
    var isFirstResponder: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField(string: text)
        textField.delegate = context.coordinator
        textField.isEditable = true
        textField.isBezeled = true
        textField.isSelectable = true
        textField.lineBreakMode = .byTruncatingTail
        textField.font = NSFont.systemFont(ofSize: 13) // Definir a fonte como preferir
        
        return textField
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
        // Certifique-se de que a janela não seja nula antes de tentar acessar o firstResponder
        if isFirstResponder, let window = nsView.window {
            DispatchQueue.main.async {
                if !window.firstResponder!.isEqual(nsView) {
                    nsView.becomeFirstResponder()
                    nsView.currentEditor()?.selectAll(nil)
                }
            }
        }
    }
}
