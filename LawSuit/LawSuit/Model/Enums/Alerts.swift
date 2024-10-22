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
        case .missingCellphoneNumber:
            return "missingCellphoneNumber"
        case .invalidLawSuitNumber:
            return "invalidLawSuitNumber"
        case .invalidCEP:
            return "invalidCEP"
        case .invalidDate:
            return "invalidDate"
        }
        
    }
    case missingInformation
    case invalidCPF
    case invalidRG
    case invalidEmail
    case missingCellphoneNumber
    case invalidLawSuitNumber
    case invalidCEP
    case invalidDate
}

enum LawsuitInvalidInformation: String, Identifiable {
    var id: String {
        switch self {
        case .missingInformation:
            return "missingInformation"
        case .lawsuitAlreadyExists:
            return "lawsuitAlreadyExists"
        case .invalidLawsuitNumber:
            return "invalidLawsuitNumber"
        }
    }
    
    case missingInformation = "missingInformation"
    case lawsuitAlreadyExists = "lawsuitAlreadyExists"
    case invalidLawsuitNumber = "invalidLawsuitNumber"
}
