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
    @Environment(\.dismiss) var dismiss
    
    //Arrumar essa coisa
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy" // Personaliza o formato da data
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 17) {
            HStack(alignment: .top, spacing: 20) {
                BoxView {
                    //						Image(systemName: "person.fill")
                    //							.resizable()
                    //							.scaledToFit()
                    //							.frame(minWidth: 50, maxWidth: 100)
                    info
                }
                .frame(maxHeight: .infinity)
                BoxView {
                    contact
                }
                .frame(maxHeight: .infinity)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(minHeight: 160)
            
            BoxView {
                address
            }
            .frame(minHeight: 222)
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 450, maxHeight: .infinity)  // MARK: Frame da View inteira
        .padding()
    }
}

extension ClientMoreInfoView {
    private var info: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(client.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(0)
                Button {
                    
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
            .padding(0)
            
            Text(client.maritalStatus)
                .padding(.bottom, 2)
            
            HStack {
                Text("\(client.age) anos")
                    .font(.headline)
                    .bold()
                Text("\(client.birthDate, formatter: dateFormatter)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 1)
            
            Text(client.occupation)
                .font(.headline)
                .bold()
                .padding(.bottom, 4)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("RG")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .bold()
                    Text(client.rg)
                        .padding(.bottom, 4)
                    
                    Text("Filiação")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .bold()
                    Text(client.affiliation)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("CPF")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .bold()
                    Text(client.cpf)
                        .padding(.bottom, 4)
                    
                    Text("Nacionalidade")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .bold()
                    Text(client.nationality)
                }
            }
            
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
        }
        .padding(.trailing, 30)
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
						 Text(client.neighborhood ?? "")
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
    }
}
