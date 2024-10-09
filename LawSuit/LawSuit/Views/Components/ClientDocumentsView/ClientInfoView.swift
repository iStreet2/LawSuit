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
    @State var imageData: Data?
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
                
                //Aqui tinha a foto po
                
                if let photo = client.photo, let nsImage = NSImage(data: photo) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                } else {
                    Button{
                        //Adicionar foto ao cliente
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 19)
                            .stroke(Color.black, lineWidth: 1)
                            .frame(width: 134, height: 134)
                            .overlay {
                                Image(systemName: "person.crop.rectangle.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 29.49)
                                    .foregroundColor(.secondary)
                            }
                    }
                    .buttonStyle(.plain)
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
                        ClientMoreInfoView(client: client, deleted: $deleted)
                        
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
        .onChange(of: deleted) { change in
            dismiss()
        }
        .sheet(isPresented: $requestDocument, content: {
            RequestDocumentsView(client: client, mailManager: mailManager)
        })
        .sheet(isPresented: $editClient, content: {
            EditClientView(client: client, deleted: $deleted)
        })
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}
