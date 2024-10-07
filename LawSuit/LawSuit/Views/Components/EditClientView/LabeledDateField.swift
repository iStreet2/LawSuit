////
////  LabeledDateField.swift
////  LawSuit
////
////  Created by Giovanna Micher on 26/08/24.
////
// NÃO PRECISAMOS MAIS DESSE COMPONENTE
//import SwiftUI
//
//struct LabeledDateField: View {
//    
//    @Binding var birthDate: Date
//    let label: String
//    @State var dateText: String
//    
////    private var dateFormatter: DateFormatter{
////        let formatter = DateFormatter()
////        formatter.dateStyle = .short
////        return formatter
////    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            LabeledTextField(label: label, placeholder: "Insira a data de nascimento do Cliente", textfieldText: $dateText )
//                    .onChange(of: dateText) { newValue in
//                        let date = newValue.convertBirthDateToDate()
//                        birthDate = date
//                    }
//                }
//        }
//        
//    }
