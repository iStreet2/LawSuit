//
//  ClientInfoView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 28/08/24.
//

import SwiftUI
import AppKit

struct ClientInfoView: View {
    
    //MARK: Variáveis de ambiente
    @Environment(\.dismiss) var dismiss
    
    //MARK: Variáveis de estado:
    @ObservedObject var client: Client
    @State var editClient = false
    @State var nsImage: NSImage?
    @Binding var deleted: Bool
    @State var requestDocument = false
    var mailManager: MailManager
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context

    
    var body: some View {
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
                        if let socialName = client.socialName {
                            Text(socialName)
                                .font(.title)
                                .bold()
                        } else {
                            Text(client.name)
                                .font(.title)
                                .bold()
                        }
                        Button {
                            // Ação para editar o cliente
                            editClient.toggle()
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 18))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    HStack {
                        Text("Celular")
                            .font(.body)
                            .bold()
                            .foregroundStyle(Color(.gray))
                        Text(client.cellphone)
                            .font(.body)
                        Text("E-mail")
                            .font(.body)
                            .bold()
                            .foregroundStyle(Color(.gray))
                        Text(client.email)
                            .font(.body)
                    }
                    .font(.footnote)
                    
                    NavigationLink {
                        ClientMoreInfoView(client: client, deleted: $deleted, nsImage: $nsImage)
                        
                    } label: {
                        Text("Mais informações")
                            .font(.body)
                            .foregroundColor(.wine)
                            .underline()
                            .bold()
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    HStack {
                        Button {
                            mailManager.sendMail(emailSubject: "Arqion", message: "")
                        } label: {
                            Text("Enviar e-mail")
                                .foregroundStyle(Color(.white))
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.black)
                        
                        Button {
                            requestDocument.toggle()
                        } label: {
                            Text("Solicitar documentos")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.black)
                        
                    }
                }
            }
            .onAppear {
                nsImage = NSImage(data: client.photo ?? Data())
            }
            .onChange(of: client) { client in
                nsImage = NSImage(data: client.photo ?? Data())
            }
        .onChange(of: deleted) { _ in
            dismiss()
        }
        .sheet(isPresented: $requestDocument, content: {
            RequestDocumentsView(client: client, mailManager: mailManager)
        })
        .sheet(isPresented: $editClient, content: {
            EditClientView(client: client, deleted: $deleted, clientNSImage: $nsImage)
        })
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}
