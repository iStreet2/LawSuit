//
//  ClientDataViewmodel.swift
//  LawSuit
//
//  Created by André Enes Pecci on 09/09/24.
//

import Foundation
import SwiftUI
import Combine

class TextFieldDataViewModel: ObservableObject {
    func limitText(text: inout String, upper: Int) {
        
        text = text.filter { $0.isLetter || $0 == " " }
        if text.count > upper {
            text = String(text.prefix(upper))
        }
    }
    
    func limitMaritalStatus(maritalStatus: inout String, upper: Int) {
        
        maritalStatus = maritalStatus.filter { $0.isLetter || $0 == " " }
        if maritalStatus.count > upper {
            maritalStatus = String(maritalStatus.prefix(upper))
        }
    }
    
    func formatNumber(_ string: String, limit: Int) -> String {
        let filtered = string.filter { "0123456789".contains($0) }
        return String(filtered.prefix(limit))
    }
    
    func formatCPF(_ cpf: String) -> String {
        let numbers = cpf.filter { "0123456789".contains($0)}
        var formatCPF = ""
        
        for (index, character) in numbers.prefix(11).enumerated() {
            if index == 3 || index == 6 {
                formatCPF.append(".")
            }
            if index == 9 {
                formatCPF.append("-")
            }
            formatCPF.append(character)
        }
        return formatCPF
    }
    
    func isValidCPF(_ cpf: String) -> Bool {
        let numbers = cpf.compactMap(\.wholeNumberValue)
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        return digitoCPF(numbers.prefix(9)) == numbers[9] &&
        digitoCPF(numbers.prefix(10)) == numbers[10]
    }
    
    func digitoCPF(_ numbers: ArraySlice<Int>) -> Int {
        var number = numbers.count + 2
        let digit = 11 - numbers.reduce(into: 0) {
            number -= 1
            $0 += $1 * number
        } % 11
        return digit > 9 ? 0 : digit
    }
    
    func formatPhoneNumber(_ phoneNumber: String, cellphone: Bool) -> String {
        let numbers = phoneNumber.filter { "0123456789".contains($0)}
        var format = ""
        
        for (index, character) in numbers.prefix(cellphone ? 11 : 10).enumerated() {
            if index == 0  {
                format.append("(")
            }
            if cellphone {
                if index == 2 {
                    format.append(") ")
                }
                if index == 7 {
                    format.append("-")
                }
            } else {
                if index == 2 {
                    format.append(") ")
                }
                if index == 6 {
                    format.append("-")
                }
            }
            format.append(character)
        }
        return format
    }
}
