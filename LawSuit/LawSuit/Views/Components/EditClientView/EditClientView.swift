//
//  EditClientView.swift
//  LawSuit
//
//  Created by Giovanna Micher on 23/08/24.
//

import SwiftUI

struct EditClientView: View {
    
    //MARK: ViewModels
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    
    //MARK: Variáveis de ambiente
    @Environment(\.dismiss) var dismiss
    
    //MARK: Variáveis de estado
    @State var userInfoType = 0
    @State var missingInformation = false
    @State var clientName: String = ""
    @State var clientOccupation: String = ""
    @State var clientRg: String = ""
    @State var clientCpf: String = ""
    @State var clientAffiliation: String = ""
    @State var clientMaritalStatus: String = ""
    @State var clientNationality: String = ""
    @State var clientBirthDate: Date = Date()
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
    
    @State var deleteAlert = false
    @ObservedObject var client: Client
    @Binding var deleted: Bool
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    LabeledTextField(label: "Nome Completo", placeholder: "Nome Completo", textfieldText: $clientName)
                    HStack {
                        LabeledDateField(selectedDate: $clientBirthDate, label: "Data de nascimento")
                        LabeledTextField(label: "Profissão", placeholder: "Profissão", textfieldText: $clientOccupation)
                            .frame(maxWidth: .infinity)
                            .padding(.leading, 30)
                    }
                    .padding(.top, 2)
                }
            }
            Picker(selection: $userInfoType, label: Text("picker")) {
                Text("Informações Pessoais").tag(0)
                Text("Endereço").tag(1)
                Text("Contato").tag(2)
                Text("Outros").tag(3)
            }
            .padding(.top, 10)
            .padding(.trailing, 100)
            .pickerStyle(.segmented)
            .labelsHidden()
            
            if userInfoType == 0 {
                EditClientViewFormsFields(formType: .personalInfo, rg: $clientRg, affiliation: $clientAffiliation, nationality: $clientNationality, cpf: $clientCpf, maritalStatus: $clientMaritalStatus, cep: $clientCep, address: $clientAddress, addressNumber: $clientAddressNumber, neighborhood: $clientNeighborhood, complement: $clientComplement, state: $clientState, city: $clientCity, email: $clientEmail, telephone: $clientTelephone, cellphone: $clientCellphone).padding(.vertical, 5)
            } else if userInfoType == 1 {
                EditClientViewFormsFields(formType: .address, rg: $clientRg, affiliation: $clientAffiliation, nationality: $clientNationality, cpf: $clientCpf, maritalStatus: $clientMaritalStatus, cep: $clientCep, address: $clientAddress, addressNumber: $clientAddressNumber, neighborhood: $clientNeighborhood, complement: $clientComplement, state: $clientState, city: $clientCity, email: $clientEmail, telephone: $clientTelephone, cellphone: $clientCellphone).padding(.vertical, 5)
            } else if userInfoType == 2 {
                EditClientViewFormsFields(formType: .contact, rg: $clientRg, affiliation: $clientAffiliation, nationality: $clientNationality, cpf: $clientCpf, maritalStatus: $clientMaritalStatus, cep: $clientCep, address: $clientAddress, addressNumber: $clientAddressNumber, neighborhood: $clientNeighborhood, complement: $clientComplement, state: $clientState, city: $clientCity, email: $clientEmail, telephone: $clientTelephone, cellphone: $clientCellphone).padding(.vertical, 5)
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
                    Alert(title: Text("Cuidado"), message: Text("Excluir seu cliente irá apagar todos os dados desse cliente e todos os processos relacionados com esse cliente!"), primaryButton: Alert.Button.destructive(Text("Apagar"), action: {
                        
                        if let lawsuits = dataViewModel.coreDataManager.lawsuitManager.fetchFromClient(client: client) {
                            for lawsuit in lawsuits {
                                dataViewModel.coreDataManager.lawsuitManager.deleteLawsuit(lawsuit: lawsuit)
                                // Após deletar os processos, deletar o cliente
                                dataViewModel.coreDataManager.clientManager.deleteClient(client: client)
                                navigationViewModel.selectedClient = nil
                                deleted.toggle()
                                dismiss()
                            }
                        } else {
                            print("Error fetching lawsuits of client: \(client.name)")
                        }
                        
                    }), secondaryButton: Alert.Button.cancel(Text("Cancelar"), action: {
                        dismiss()
                    }))
                })
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Cancelar")
                }
                Button(action: {
                    if areFieldsFilled() {
                        dataViewModel.coreDataManager.clientManager.editClient(client: client, name: clientName, occupation: clientOccupation, rg: clientRg, cpf: clientCpf, affiliation: clientAffiliation, maritalStatus: clientMaritalStatus, nationality: clientNationality, birthDate: clientBirthDate, cep: clientCep, address: clientAddress, addressNumber: clientAddressNumber, neighborhood: clientNeighborhood, complement: clientComplement, state: clientState, city: clientCity, email: clientEmail, telephone: clientTelephone, cellphone: clientCellphone)
                        dismiss()
                    } else {
                        missingInformation = true
                    }
                }, label: {
                    Text("Salvar")
                })
                .buttonStyle(.borderedProminent)
                .alert(isPresented: $missingInformation) {
                    Alert(title: Text("Informações Faltando"),
                          message: Text("Por favor, preencha todos os campos antes de salvar."),
                          dismissButton: .default(Text("Ok")))
                }
            }
        }
        .frame(minHeight: 250)
        .padding()
        .onAppear {
            clientName = client.name
            clientOccupation = client.occupation
            clientRg = client.rg
            clientCpf = client.cpf
            clientAffiliation = client.affiliation
            clientMaritalStatus = client.maritalStatus
            clientNationality = client.nationality
            clientBirthDate = client.birthDate
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
        }
    }
    func areFieldsFilled() -> Bool {
        if userInfoType >= 0 {
            return !clientName.isEmpty &&
            !clientOccupation.isEmpty &&
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
            !clientComplement.isEmpty &&
            !clientState.isEmpty &&
            !clientCity.isEmpty
            !clientEmail.isEmpty &&
            !clientTelephone.isEmpty &&
            !clientCellphone.isEmpty
        }
        return true
    }
}
