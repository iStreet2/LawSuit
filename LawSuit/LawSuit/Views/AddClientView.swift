//
//  AddClientView.swift
//  LawSuit
//
//  Created by André Enes Pecci on 22/08/24.
//

import SwiftUI
import Combine

struct AddClientView: View {
    
    //MARK: Environments
    @EnvironmentObject var textFieldDataViewModel: TextFieldDataViewModel
    @Environment(\.dismiss) var dismiss
    
    //MARK: Variáveis de estado
    @State var stage: Int = 1
    @State var invalidInformation: InvalidInformation?
    @State var name: String = ""
    @State var socialName: String = ""
    @State var occupation: String = ""
    @State var rg: String = ""
    @State var cpf: String = ""
    @State var affiliation: String = ""
    @State var maritalStatus: String = ""
    @State var nationality: String = ""
    @State var birthDate: String = ""
    @State var cep: String = ""
    @State var address: String = ""
    @State var addressNumber: String = ""
    @State var neighborhood: String = ""
    @State var complement: String = ""
    @State var state: String = ""
    @State var city: String = ""
    @State var email: String = ""
    @State var telephone: String = ""
    @State var cellphone: String = ""
    @State var isClientContactsToggleOn: Bool = false
    @EnvironmentObject var contactsManager: ContactsManager
    @State var photo: Data?
    
    @State private var timer: Timer? = nil
    @State private var startTime: Date? = nil
    @State private var elapsedTime: TimeInterval = 0
    @State private var isRunning: Bool = false
    
    @State private var isTeste1: Bool = false
    @State private var tempoTeste1: TimeInterval = 0
    @State private var tempoTeste2: TimeInterval = 0
    
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @EnvironmentObject var pdfViewModel: PDFViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var lawyers: FetchedResults<Lawyer>
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        Text("Novo Cliente")
                            .font(.title)
                            .bold()
                            .padding(.horizontal, 15)
                        Spacer()
                    }
                    //MARK: ProgressBar
                    AddClientProgressView(stage: $stage)
                }
                .padding(.vertical, 7)
                Spacer()
                Divider()
                VStack(spacing: 0) {
                    AddClientForm(stage: $stage, name: $name, socialName: $socialName, occupation: $occupation, rg: $rg, cpf: $cpf, affiliation: $affiliation, maritalStatus: $maritalStatus, nationality: $nationality, birthDate: $birthDate, cep: $cep, address: $address, addressNumber: $addressNumber, neighborhood: $neighborhood, complement: $complement, state: $state, city: $city, email: $email, telephone: $telephone, cellphone: $cellphone, photo: $photo)
                }
                .padding()
                .background(Color("ScrollBackground"))
                Divider()
                Spacer()
                //MARK: Botões
                HStack {
                    
                    Button {
                        //abrir pra escolher pdf hehe
                        pdfViewModel.getPDFurl { url in
                            if let url = url {
                                pdfViewModel.loadDocument(pdfURL: url)
                                print("URL do arquivo PDF: \(url)")
                                
                                pdfViewModel.updateFieldsFromPDF(clientName: &name, clientCPF: &cpf, clientBirthDate: &birthDate, clientAffiliation: &affiliation, clientTelephone: &telephone, clientEmail: &email)
                            } else {
                                print("Nenhum arquivo selecionado")
                            }
                        }
                        print("clicou pra abrir pdf")
                    } label: {
                        Text("Importar Dados")
                            .foregroundStyle(.wine)
                    }
                    
                    Toggle(isOn: $isClientContactsToggleOn) {
                        Text("Adicionar aos Contatos")
                    }
//                    Button {
//                        startTimer()
//                        isTeste1 = true
//                    } label: {
//                        Text("Teste1")
//                            .padding(10)
//                            .background(Color.green)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .disabled(isRunning)
//                    .buttonStyle(.plain)
//                    
//                    Button {
//                        startTimer()
//                        name = "Gabriel Vicentin Negro"
//                        cpf = "52553733895"
//                        affiliation = "Sônia Maria de Lurdes"
//                        birthDate = "10042003"
//                        email = "gabriel.vic@outlook.com"
//                        cellphone = "11976590460"
//                    } label: {
//                        Text("Teste2")
//                            .padding(10)
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .disabled(isRunning)
//                    .buttonStyle(.plain)

                    Spacer()
                    Button(action: {
                        if stage == 1 {
                            dismiss()
                        }
                        else {
                            if stage > 1 {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    stage -= 1
                                }
                            }
                        }
                    }, label: {
                        if stage == 1 {
                            Text("Cancelar")
                        }
                        else {
                            Text("Voltar")
                        }
                    })
                    Button(action: {
                        if !areFieldsFilled(){
                            invalidInformation = .missingInformation
                            return
                        }
                        if  cpf.count < 14 || !textFieldDataViewModel.isValidCPF(cpf) {
                            invalidInformation = .invalidCPF
                            return
                        }
                        if rg.count < 9 {
                            invalidInformation = .invalidRG
                            return
                        }
                        if textFieldDataViewModel.dateValidation(birthDate) {
                            invalidInformation = .invalidDate
                            return
                        }
                        if stage == 2 {
                            if cep.count < 8 {
                                invalidInformation = .invalidCEP
                                return
                            }
                        }
                        if stage == 3 {
                            //stopTimer()
                            
//                            if isTeste1 {
//                                if let startTime = startTime {
//                                    tempoTeste1 = elapsedTime
//                                    print("Tempo teste 1: \(tempoTeste1)")
//                                }
//                            } else {
//                                if let startTime = startTime {
//                                    tempoTeste2 = elapsedTime
//                                    print("Tempo teste 2: \(tempoTeste2)")
//                                }
//                            }
                            //print(("Tempo decorrido: \(elapsedTime/*, specifier: "%.2f"*/) segundos"))
                            if isClientContactsToggleOn {
                                let contact = contactsManager.createContact(name: socialName == "" ? name : socialName, cellphone: cellphone, email: email, photo: photo ?? Data(), occupation: occupation)
                                contactsManager.checkContactsAuthorizationAndSave(contact: contact)
                            }
                            
                            if !textFieldDataViewModel.isValidEmail(email) {
                                invalidInformation = .invalidEmail
                            } else if cellphone.count < 15 {
                                invalidInformation = .missingCellphoneNumber
                            }
                            else {
                                //MARK: Advogado temporário
                                let lawyer = lawyers[0]
                                let _ = dataViewModel.coreDataManager.clientManager.createClient(name: name, socialName: socialName == "" ? nil : socialName, occupation: occupation, rg: rg, cpf: cpf, lawyer: lawyer, affiliation: affiliation, maritalStatus: maritalStatus, nationality: nationality, birthDate: birthDate.convertBirthDateToDate(), cep: cep, address: address, addressNumber: addressNumber, neighborhood: neighborhood, complement: complement, state: state, city: city, email: email, telephone: telephone, cellphone: cellphone, photo: photo)
                                
                                pdfViewModel.resetFields()
                                dismiss()
                            }
                            return
                        }
                        if stage < 3 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                stage += 1
                            }
                        }
                    }, label: {
                        if stage == 3 {
                            Text("Adicionar Cliente")
                        }
                        else {
                            Text("Próximo")
                        }
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                    .alert(item: $invalidInformation) { error in
                        switch error {
                        case .missingInformation:
                            return Alert(title: Text("Informações Faltando"),
                                         message: Text("Por favor, preencha todos os campos antes de continuar."),
                                         dismissButton: .default(Text("Ok")))
                        case .invalidCPF:
                            return Alert(title: Text("CPF inválido"),
                                         message: Text("Por favor, insira um CPF válido antes de continuar."),
                                         dismissButton: .default(Text("Ok")))
                            
                        case .invalidRG:
                            return Alert(title: Text("RG inválido"),
                                         message: Text("Por favor, insira um RG válido antes de continuar"),
                                         dismissButton: .default(Text("Ok")))
                        case .invalidEmail:
                            return Alert(title: Text("E-mail inválido"),
                                         message: Text("Por favor, insira um e-mail válido antes de continuar"),
                                         dismissButton: .default(Text("Ok")))
                        case .missingCellphoneNumber:
                            return Alert(title: Text("Número de celular inválido"),
                                         message: Text("Por favor, insira um número de celular válido antes de continuar"),
                                         dismissButton: .default(Text("Ok")))
                        case .invalidLawSuitNumber:
                            return Alert(title: Text(""),
                                         message: Text(""),
                                         dismissButton: .default(Text("")))
                        case .invalidCEP:
                            return Alert(title: Text("Número de CEP não encontrado"),
                                         message: Text("Por favor, insira um número de CEP válido antes de continuar"),
                                         dismissButton: .default(Text("Ok")))
                        case .invalidDate:
                            return Alert(title: Text("Data de nascimento inválida"),
                                         message: Text("Por favor, insira uma data válida antes de continuar"),
                                         dismissButton: .default(Text("Ok")))
                        }
                    }
                }
                .padding(.vertical, 7)
                .padding(.horizontal, 10)
            }
            .padding(.vertical, 5)
            .frame(width: 515, height: 500)
        }
    }
    
//    func startTimer() {
//        startTime = Date()
//        isRunning = true
//        
//        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
//            if let startTime = startTime {
//                elapsedTime = Date().timeIntervalSince(startTime)
//            }
//        }
//    }
//    
//    // Função para parar o timer
//    func stopTimer() {
//        timer?.invalidate()
//        timer = nil
//        isRunning = false
//        
//        if let startTime = startTime {
//            let finalTime = Date().timeIntervalSince(startTime)
//            //print("Tempo total: \(finalTime) segundos")
//        }
//    }
    
    // Função para verificar se todos os campos estão preenchidos de acordo com o stage
    func areFieldsFilled() -> Bool {
        if stage == 1 {
            return !name.isEmpty &&
            !rg.isEmpty &&
            !affiliation.isEmpty &&
            !nationality.isEmpty &&
            !maritalStatus.isEmpty &&
            !birthDate.description.isEmpty
        } else if stage == 2 {
            return !cep.isEmpty &&
            !address.isEmpty &&
            !addressNumber.isEmpty &&
            !neighborhood.isEmpty &&
            !city.isEmpty &&
            !state.isEmpty
        } else if stage == 3 {
            return !email.isEmpty &&
            !cellphone.isEmpty
        }
        return true
    }
}

