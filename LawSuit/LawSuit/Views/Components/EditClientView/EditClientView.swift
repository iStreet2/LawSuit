//
//  EditClientView.swift
//  LawSuit
//
//  Created by Giovanna Micher on 23/08/24.
//

import SwiftUI
import Combine

struct EditClientView: View {
    
    //MARK: ViewModels
    @EnvironmentObject var textFieldDataViewModel: TextFieldDataViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var addressViewModel: AddressViewModel
    @EnvironmentObject var folderViewModel: FolderViewModel
    
    //MARK: Variáveis de ambiente
    @Environment(\.dismiss) var dismiss
    
    //MARK: Variáveis de estado
    @State var invalidInformation: InvalidInformation?
    @State var userInfoType = 0
    @State var clientName: String = ""
    @State var clientSocialName: String = ""
    @State var clientOccupation: String = ""
    @State var clientRg: String = ""
    @State var clientCpf: String = ""
    @State var clientAffiliation: String = ""
    @State var clientMaritalStatus: String = ""
    @State var clientNationality: String = ""
    @State var clientBirthDate: String = ""
    @State var clientCep: String = ""
    @State var clientAddress: String = ""
    @State var clientAddressNumber: String = ""
    @State var clientNeighborhood: String = ""
    @State var clientComplement: String = ""
    @State var clientState: String = ""
    @State var clientCity: String = ""
    @State var clientEmail: String = ""
    @State var clientTelephone: String = ""
    @State var clientCellphone: String = ""
    @State var clientImageData: Data?
    
    @State var selectedOption = "Informações Pessoais"
    var infos = ["Informações Pessoais", "Endereço", "Contato"]
    
    let textLimit = 50
    let maritalStatusLimit = 10
    
    @State var deleteAlert = false
    @State var remove = false
    @ObservedObject var client: Client
    @Binding var deleted: Bool
    @Binding var clientNSImage: NSImage?
    @State var clientNSImageBakcup: NSImage?
    @State var showError: Bool = false
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                Group {
                    if let clientNSImage {
                        Button {
                            withAnimation {
                                self.clientNSImage = nil
                                self.clientImageData = nil
                            }
                        } label: {
                            if remove {
                                RemovePhotoButton(image: Image(nsImage: clientNSImage))
                                    .cornerRadius(19)
                            } else {
                                Image(nsImage: clientNSImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 134, height: 134)
                                    .cornerRadius(19)
                            }
                        }
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                        .buttonStyle(.plain)
                        .onHover { hovering in
                            if hovering {
                                withAnimation(.bouncy) {
                                    remove = true
                                }
                            } else {
                                withAnimation(.bouncy) {
                                    remove = false
                                }
                            }
                        }
                        
                    } else {
                        Button{
                            //Adicionar foto ao cliente
                            folderViewModel.importPhoto { data in
                                if let data = data {
                                    withAnimation(.bouncy) {
                                        self.clientImageData = data
                                        self.clientNSImage = NSImage(data: data)
                                    }
                                }
                            }
                        } label: {
                            AddPhotoButton()
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .buttonStyle(.plain)
                
                VStack(alignment: .leading) {
                    LabeledTextField(label: "Nome Civil", placeholder: "Insira o Nome Civil do Cliente", mandatory: true, textfieldText: $clientName)
                        .onReceive(Just(clientName)) { _ in textFieldDataViewModel.limitText(text: &clientName, upper: textLimit) }
                    LabeledTextField(label: "Data de nascimento", placeholder: "Insira a data de nascimento do Cliente", mandatory: true, textfieldText: $clientBirthDate)
                        .onReceive(Just(clientBirthDate)) { _ in
                            clientBirthDate = textFieldDataViewModel.dateFormat(clientBirthDate)}
                        .onChange(of: clientBirthDate) { newValue in
                                    if clientBirthDate.count > 00 && clientBirthDate.count == 10  {
                                        showError = textFieldDataViewModel.dateValidation(clientBirthDate)
                                    } else {
                                        showError = false
                                    }
                                }
                            Text(showError ? "Data inválida" : "")
                                .foregroundColor(.red)
                                .font(.callout)
                                .frame(height: 20)
                        
                }
                .padding()
            }
            HStack {
                CustomSegmentedControl(selectedOption: $selectedOption, infos: infos)
                    .padding(.horizontal, 15)
                Spacer()
            }
            Spacer()
            Divider()
            Group {
                VStack(spacing: 0) {
                    if selectedOption == "Informações Pessoais" {
                        EditClientViewFormsFields(formType: .personalInfo, addressViewModel: addressViewModel, rg: $clientRg, socialName: $clientSocialName, affiliation: $clientAffiliation, nationality: $clientNationality, cpf: $clientCpf, maritalStatus: $clientMaritalStatus, Occupation: $clientOccupation, cep: $clientCep, address: $clientAddress, addressNumber: $clientAddressNumber, neighborhood: $clientNeighborhood, complement: $clientComplement, state: $clientState, city: $clientCity, email: $clientEmail, telephone: $clientTelephone, cellphone: $clientCellphone)
                    } else if selectedOption == "Endereço" {
                        EditClientViewFormsFields(formType: .address, addressViewModel: addressViewModel, rg: $clientRg, socialName: $clientSocialName, affiliation: $clientAffiliation, nationality: $clientNationality, cpf: $clientCpf, maritalStatus: $clientMaritalStatus, Occupation: $clientOccupation, cep: $clientCep, address: $clientAddress, addressNumber: $clientAddressNumber, neighborhood: $clientNeighborhood, complement: $clientComplement, state: $clientState, city: $clientCity, email: $clientEmail, telephone: $clientTelephone, cellphone: $clientCellphone)
                            .background(Color("ScrollBackground"))
                    } else if selectedOption == "Contato" {
                        EditClientViewFormsFields(formType: .contact, addressViewModel: addressViewModel, rg: $clientRg, socialName: $clientSocialName, affiliation: $clientAffiliation, nationality: $clientNationality, cpf: $clientCpf, maritalStatus: $clientMaritalStatus, Occupation: $clientOccupation, cep: $clientCep, address: $clientAddress, addressNumber: $clientAddressNumber, neighborhood: $clientNeighborhood, complement: $clientComplement, state: $clientState, city: $clientCity, email: $clientEmail, telephone: $clientTelephone, cellphone: $clientCellphone)
                            .background(Color("ScrollBackground"))
                    }
                }
                .padding(.horizontal)
                .background(Color("ScrollBackground"))
                Divider()
            }
            Spacer()
            HStack {
                Button {
                    deleteAlert.toggle()
                } label: {
                    Text("Apagar Cliente")
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .alert(isPresented: $deleteAlert, content: {
                    Alert(title: Text("Você tem certeza?"), message: Text("Excluir seu cliente irá apagar todos os dados relacionados a ele, incluindo seus processos!"), primaryButton: Alert.Button.destructive(Text("Apagar"), action: {
                        if let lawsuits = dataViewModel.coreDataManager.lawsuitManager.fetchFromClient(client: client) {
                            for lawsuit in lawsuits {
                                dataViewModel.coreDataManager.lawsuitManager.deleteLawsuit(lawsuit: lawsuit)
                            }
                            // Após deletar os processos, deletar o cliente
                            dataViewModel.coreDataManager.clientManager.deleteClient(client: client)
                            
                            dataViewModel.spotlightManager.removeIndexedObject(client)
                            
                            navigationViewModel.selectedClient = nil
                            deleted.toggle()
                            dismiss()
                        } else {
                            print("Error fetching lawsuits of client: \(client.name)")
                        }
                    }), secondaryButton: Alert.Button.cancel(Text("Cancelar"), action: {
                    }))
                })
                Spacer()
                Button {
                    withAnimation {
                        clientNSImage = clientNSImageBakcup
                    }
                    dismiss()
                } label: {
                    Text("Cancelar")
                }
                Button(action: {
                    if !areFieldsFilled() {
                        invalidInformation = .missingInformation
                        return
                    }
                    if clientCpf.count < 14 || !textFieldDataViewModel.isValidCPF(clientCpf) {
                        invalidInformation = .invalidCPF
                        return
                    }
                    if clientRg.count < 9 {
                        invalidInformation = .invalidRG
                        return
                    }
                    if !textFieldDataViewModel.isValidEmail(clientEmail) {
                        invalidInformation = .invalidEmail
                        return
                    }
                    if clientCellphone.count < 15 {
                        invalidInformation = .missingCellphoneNumber
                        
                    } 
                    if textFieldDataViewModel.dateValidation(clientBirthDate) {
                        invalidInformation = .invalidDate
                    }
                    else {
                        dataViewModel.coreDataManager.clientManager.editClient(client: client, name: clientName, socialName: clientSocialName == "" ? nil : clientSocialName, occupation: clientOccupation, rg: clientRg, cpf: clientCpf, affiliation: clientAffiliation, maritalStatus: clientMaritalStatus, nationality: clientNationality, birthDate: clientBirthDate.convertBirthDateToDate(), cep: clientCep, address: clientAddress, addressNumber: clientAddressNumber, neighborhood: clientNeighborhood, complement: clientComplement, state: clientState, city: clientCity, email: clientEmail, telephone: clientTelephone, cellphone: clientCellphone, photo: clientImageData)
                        dismiss()
                        return
                    }
                }, label: {
                    Text("Salvar")
                })
                .tint(.black)
                .buttonStyle(.borderedProminent)
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
                        return Alert(title: Text("Número do processo inválido"),
                                     message: Text("Por favor, insira um número de processo válido antes de continuar"),
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
        .frame(width: 515, height: 500)
        .padding(.vertical, 5)
        .onAppear {
            clientName = client.name
            clientSocialName = client.socialName ?? ""
            clientOccupation = client.occupation
            clientRg = client.rg
            clientCpf = client.cpf
            clientAffiliation = client.affiliation
            clientMaritalStatus = client.maritalStatus
            clientNationality = client.nationality
            clientBirthDate = client.birthDate.convertBirthDateToString()
            clientCep = client.cep
            clientAddress = client.address
            clientAddressNumber = client.addressNumber
            clientNeighborhood = client.neighborhood
            clientComplement = client.complement
            clientState = client.state
            clientCity = client.city
            clientEmail = client.email
            clientTelephone = client.telephone
            clientCellphone = client.cellphone
            clientImageData = client.photo
            clientNSImageBakcup = clientNSImage
        }
    }
    func areFieldsFilled() -> Bool {
        if userInfoType >= 0 {
            return !clientName.isEmpty &&
            !clientBirthDate.description.isEmpty &&
            !clientRg.isEmpty &&
            !clientCpf.isEmpty &&
            !clientAffiliation.isEmpty &&
            !clientMaritalStatus.isEmpty &&
            !clientNationality.isEmpty &&
            !clientCep.isEmpty &&
            !clientAddress.isEmpty &&
            !clientAddressNumber.isEmpty &&
            !clientNeighborhood.isEmpty &&
            !clientState.isEmpty &&
            !clientCity.isEmpty &&
            !clientEmail.isEmpty &&
            !clientCellphone.isEmpty
        }
        return true
    }
}
