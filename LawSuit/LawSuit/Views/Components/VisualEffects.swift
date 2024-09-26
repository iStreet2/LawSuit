//
//  VisualEffects.swift
//  LawSuit
//
//  Created by André Arteca on 26/09/24.
//

import Foundation
import SwiftUI


class TransparentWindowView: NSView {
  override func viewDidMoveToWindow() {
    window?.backgroundColor = .clear
      window?.backgroundColor = .clear
      super.viewDidMoveToWindow()
  }
}

struct TransparentWindow: NSViewRepresentable {
   func makeNSView(context: Self.Context) -> NSView {
       return TransparentWindowView() }
   func updateNSView(_ nsView: NSView, context: Context) { }
}


struct MaterialWindow: NSViewRepresentable {
    func makeNSView(context: Self.Context) -> NSView {

        let nsView =  NSVisualEffectView()
        nsView.material = .hudWindow

        return nsView
    }
   func updateNSView(_ nsView: NSView, context: Context) { }
}




struct VisualEffect: NSViewRepresentable {
    func makeNSView(context: Context) -> some NSView { return NSVisualEffectView() }
    func updateNSView(_ nsView: NSViewType, context: Context) { }
}


