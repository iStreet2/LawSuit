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
        case .invalidEmail:
            return "invalidEmail"
        case .missingTelephoneNumber:
            return "missingTelephoneNumber"
        case .missingCellphoneNumber:
            return "missingCellphoneNumber"
        }
    }
    case missingInformation
    case invalidCPF
    case invalidRG
    case invalidEmail
    case missingTelephoneNumber
    case missingCellphoneNumber
}
