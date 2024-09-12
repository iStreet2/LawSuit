//
//  Alerts.swift
//  LawSuit
//
//  Created by André Enes Pecci on 12/09/24.
//

import Foundation

enum InvalidInformation: Error, Identifiable {
    var id: String {
        switch self {
        case .missingInformation:
            return "missingInformation"
        case .invalidCPF:
            return "invalidCPF"
        case .invalidRG:
            return "invalidRG"
        }
    }
    case missingInformation
    case invalidCPF
    case invalidRG
}
