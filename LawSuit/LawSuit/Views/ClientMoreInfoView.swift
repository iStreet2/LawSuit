//
//  ClientMoreInfoView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 28/08/24.
//

import Foundation
import SwiftUI

struct BoxView<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(10)
            .background(
                Color.secondary
                    .clipShape(RoundedRectangle(cornerRadius: 7).stroke())
            )
    }
}


struct ClientMoreInfoView: View {
    
    @ObservedObject var client: Client
    @State var editClient = false
    @Environment(\.dismiss) var dismiss
    @Binding var deleted: Bool
    @Binding var nsImage: NSImage?
    
    //Arrumar essa coisa
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy" // Personaliza o formato da data
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                BoxView {
                    info
                }
                .frame(height: 200)
            }
            HStack(alignment: .top, spacing: 20) {
                BoxView {
                    address
                }
                .frame(maxHeight: .infinity)
                BoxView {
                    contact
                }
                .frame(maxHeight: .infinity)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(minHeight: 160)
            Spacer()
        }
        .sheet(isPresented: $editClient, content: {
            EditClientView(client: client, deleted: $deleted, clientNSImage: $nsImage)
        })
        .frame(minWidth: 800, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)  // MARK: Frame da View inteira
        .padding()
    }
}

extension ClientMoreInfoView {
    
    private var info: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                if let nsImage {
                    Image(nsImage: nsImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .cornerRadius(10)
                }
                VStack(alignment: .leading) {
                    HStack {
                        if client.socialName != nil {
                            Text(client.socialName!)
                                .font(.largeTitle)
                                .bold()
                                .padding(0)
                        } else {
                            Text(client.name)
                                .font(.largeTitle)
                                .bold()
                                .padding(0)
                        }
                        Spacer()
                        Button {
                            editClient.toggle()
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 27)
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(0)
                    }
                    HStack {
                        Text("\(client.age) anos")
                            .font(.headline)
                            .bold()
                        Text("\(client.birthDate, formatter: dateFormatter)")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 1)
                }
            }
            .padding(0)
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            if client.socialName != nil {
                                Text("Nome Civil")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .bold()
                                Text(client.name)
                                    .padding(.bottom, 4)
                            } else {
                                Text("Profissão")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .bold()
                                Text(client.occupation)
                                    .padding(.bottom, 4)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: geometry.size.width * 0.20)
                        
                        VStack(alignment: .leading) {
                            Text("RG")
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .bold()
                            Text(client.rg)
                                .padding(.bottom, 4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: geometry.size.width * 0.20)

                        VStack(alignment: .leading) {
                            Text("CPF")
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .bold()
                            Text(client.cpf)
                                .padding(.bottom, 4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: geometry.size.width * 0.20)
                    }
                    
                    //MARK: Estado civil e profissão
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            if client.socialName == nil {
                                Text("Estado civil")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(client.maritalStatus)
                                    .padding(.bottom, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } 
                            else {
                                Text("Profissão")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(client.occupation)
                                    .padding(.bottom, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .frame(width: geometry.size.width * 0.20)
                        
                        //MARK: Nacionalidade e Estado civil
                        VStack(alignment: .leading) {
                            if client.socialName == nil {
                                Text("Nacionalidade")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(client.nationality)
                                    .padding(.bottom, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            else {
                                Text("Estado civil")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(client.maritalStatus)
                                    .padding(.bottom, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .frame(width: geometry.size.width * 0.20)
                        
                        //MARK: Filiação e Nacionalidade
                        VStack(alignment: .leading) {
                            if client.socialName == nil {
                                Text("Filiação")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .bold()
                                Text(client.affiliation)
                                    .padding(.bottom, 4)
                            }
                            else {
                                Text("Nacionalidade")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .bold()
                                Text(client.nationality)
                                    .padding(.bottom, 4)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: geometry.size.width * 0.20)
                        
                        //MARK: apenas Filiação
                        VStack(alignment: .leading) {
                            if client.socialName == nil {
                            }
                            else {
                                Text("Filiação")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .bold()
                                Text(client.affiliation)
                                    .padding(.bottom, 4)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: geometry.size.width * 0.20)
                    }
                }
            }
//            .border(.gray)
//            .frame(height: 100)
        }
        .onAppear {
            self.nsImage = NSImage(data: client.photo ?? Data())
        }
        .onChange(of: deleted) { change in
            dismiss()
        }
    }
    
    private var contact: some View {
        VStack(alignment: .leading) {
            Text("Contato")
                .font(.title2)
                .bold()
                .padding(.bottom, 7)
            
            Text("Email")
                .font(.body)
                .bold()
                .foregroundStyle(.secondary)
            Text(client.email)
                .font(.body)
                .padding(.bottom, 7)
            
            Text("Telefone")
                .font(.body)
                .bold()
                .foregroundStyle(.secondary)
            Text(client.telephone)
                .font(.body)
                .padding(.bottom, 7)
            
            Text("Celular")
                .font(.body)
                .bold()
                .foregroundStyle(.secondary)
            Text(client.cellphone)
                .font(.body)
                .padding(.bottom, 22)
            
            Text("Quer ter fácil acesso às informações de seu cliente?")
                .foregroundStyle(.secondary)
            Button {
            } label: {
                Text("Adicionar aos Contatos")
            }
            .buttonStyle(.borderedProminent)
            .tint(.black)
        }
        .padding(.trailing, 10)
    }
    
    private var address: some View {
        VStack(alignment: .leading) {
            Text("Endereço")
                .font(.title2)
                .bold()
                .padding(.bottom, 7)
            Text("CEP")
                .font(.body)
                .foregroundStyle(.secondary)
                .bold()
            Text(client.cep)
                .padding(.bottom, 7)
            Text("Endereço")
                .font(.body)
                .foregroundStyle(.secondary)
                .bold()
            Text("\(client.address), \(client.addressNumber)")
                .padding(.bottom, 7)
            HStack {
                VStack(alignment: .leading) {
                    Text("Bairro")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .bold()
                    Text(client.neighborhood)
                        .padding(.bottom, 7)
                    
                    Text("Cidade")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .bold()
                    Text(client.city)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Complemento")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .bold()
                    Text(client.complement)
                        .padding(.bottom, 7)
                    
                    Text("Estado")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .bold()
                    Text(client.state)
                }
                Spacer()
            }
        }
        .padding(.bottom, 30)
    }
}
