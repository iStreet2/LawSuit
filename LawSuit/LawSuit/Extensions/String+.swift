//
//  String+.swift
//  LawSuit
//
//  Created by Giovanna Micher on 12/09/24.
//

import Foundation
import SwiftUI

extension String {
    func convertToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: self) ?? Date()
    }
    
  
    func copy() {
        //            #if os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(self, forType: .string)
        //            #else
        //            UIPasteboard.general.string = self
        //            #endif
    }
}
