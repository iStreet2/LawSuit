//
//  String+.swift
//  LawSuit
//
//  Created by Giovanna Micher on 12/09/24.
//

import Foundation

extension String {
    func convertToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: self) ?? Date()
    }
}
