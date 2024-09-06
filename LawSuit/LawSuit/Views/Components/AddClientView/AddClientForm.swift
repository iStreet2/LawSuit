//
//  AddClientType.swift
//  LawSuit
//
//  Created by André Enes Pecci on 27/08/24.
//

import SwiftUI
import Combine

enum ClientType {
    case personalInfo, address, contact, others
}

struct AddClientForm: View {
    
    @Binding var stage: Int
    @State var states = ["São Paulo", "Rio de Janeiro", "Mato Grosso do Sul", "Minas Gerais", "Rio Grande do Sul", "Acre", "Ceará"]
    @State var cities = ["São Paulo", "Mogi das Cruzes", "Maringá", "Iaras", "Osasco", "Carapicuíba", "Barueri"]
    
    @Binding var name: String
    @Binding var occupation: String
    @Binding var rg: String
    @Binding var cpf: String
    @Binding var affiliation: String
    @Binding var maritalStatus: String
    @Binding var nationality: String
    @Binding var birthDate: Date
    @Binding var cep: String
    @Binding var address: String
    @Binding var addressNumber: String
    @Binding var neighborhood: String
    @Binding var complement: String
    @Binding var state: String
    @Binding var city: String
    @Binding var email: String
    @Binding var telephone: String
    @Binding var cellphone: String
    
    let textLimit = 50
    let maritalStatusLimit = 10
    
    var body: some View {
        // if stage == 1
        if stage == 1 {
            HStack {
                VStack(spacing: 15) {
                    LabeledTextField(label: "Nome Completo", placeholder: "Insira o nome do Cliente", textfieldText: $name)
                        .onReceive(Just(name)) { _ in limitText(textLimit) }
                    LabeledTextField(label: "RG", placeholder: "Insira o RG do Cliente", textfieldText: $rg)
                        .onReceive(Just(rg)) { _ in rg = filterNumbers(rg, limit: 9) }
                    LabeledTextField(label: "Filiação", placeholder: "Insira a Filiação do Cliente", textfieldText: $affiliation)
                        .onReceive(Just(affiliation)) { _ in limitText(textLimit) }
                    LabeledTextField(label: "Nacionalidade", placeholder: "Insira a Nacionalidade do Cliente", textfieldText: $nationality)
                        .onReceive(Just(nationality)) { _ in limitText(textLimit) }
                }
                VStack(alignment: .leading, spacing: 15) {
                    LabeledTextField(label: "Profissão", placeholder: "Insira a Profissão do Cliente", textfieldText: $occupation)
                        .onReceive(Just(occupation)) { _ in limitText(textLimit) }
                    LabeledTextField(label: "CPF", placeholder: "Insira o CPF do Cliente", textfieldText: $cpf)
                        .onReceive(Just(cpf)) { _ in cpf = formatCPF(cpf) }
                        .foregroundStyle(cpf.isValidCPF ? .black : .red)
                    LabeledTextField(label: "Estado Civil", placeholder: "Insira o Estado Civil do Cliente", textfieldText: $maritalStatus)
                        .onReceive(Just(maritalStatus)) { _ in limitMaritalStatus(maritalStatusLimit) }
                    LabeledDateField(selectedDate: $birthDate, label: "Insira a Data de nascimento do Cliente")
                    
                }
            }
            .padding(.vertical, 5)
        } else if stage == 2 {
            VStack(alignment: .leading, spacing: 15) {
                LabeledTextField(label: "CEP", placeholder: "Insira seu CEP", textfieldText: $cep)
                LabeledTextField(label: "Endereço", placeholder: "Insira seu endereço", textfieldText: $address)
                HStack(spacing: 10) {
                    LabeledTextField(label: "Número", placeholder: "Insira o número", textfieldText: $addressNumber)
                        .frame(width: 120)
                    LabeledTextField(label: "Bairro", placeholder: "Insira seu bairro", textfieldText: $neighborhood)
                    LabeledTextField(label: "Complemento", placeholder: "Insira o complemento", textfieldText: $complement)
                        .frame(width: 170)
                }
                HStack(spacing: 20) {
                    LabeledPickerField(selectedOption: $state, arrayInfo: states, label: "Estado")
                    Spacer()
                    LabeledPickerField(selectedOption: $city, arrayInfo: cities, label: "Cidade")
                }
                .frame(width: 250)
            }
            .padding(.vertical, 5)
        } else if stage == 3 {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 15) {
                    LabeledTextField(label: "E-mail", placeholder: "Insira seu e-mail", textfieldText: $email)
                    HStack(spacing: 60) {
                        LabeledTextField(label: "Telefone", placeholder: "Insira seu telefone", textfieldText: $telephone)
                        LabeledTextField(label: "Celular", placeholder: "Insira seu celular", textfieldText: $cellphone)
                    }
                }
            }
            Spacer()
                .padding(.vertical, -5)
        }
    }
    func limitText(_ upper: Int) {
        if name.count > upper {
            name = String(name.prefix(upper))
        }
        if affiliation.count > upper {
            affiliation = String(affiliation.prefix(upper))
        }
        if nationality.count > upper {
            nationality = String(nationality.prefix(upper))
        }
        if occupation.count > upper {
            occupation = String(occupation.prefix(upper))
        }
    }
    func limitMaritalStatus(_ upper: Int) {
        if maritalStatus.count > upper {
            maritalStatus = String(maritalStatus.prefix(upper))
        }
    }
    func filterNumbers(_ string: String, limit: Int) -> String {
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
}


extension Collection where Element == Int {
    var digitoCPF: Int {
        var number = count + 2
        let digit = 11 - reduce(into: 0) {
            number -= 1
            $0 += $1 * number
        } % 11
        return digit > 9 ? 0 : digit
    }
}
extension StringProtocol {
    var isValidCPF: Bool {
        let numbers = compactMap(\.wholeNumberValue)
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        return numbers.prefix(9).digitoCPF == numbers[9] &&
               numbers.prefix(10).digitoCPF == numbers[10]
    }
}
