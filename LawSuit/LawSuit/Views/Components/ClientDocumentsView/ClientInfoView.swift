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
    var mailManager: MailManager 
    @State var requestDocument = false


    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack {
                    Text(client.name)
                        .font(.title)
                        .bold()
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
                        .bold()
                        .foregroundStyle(Color(.gray))
                    Text(client.cellphone)
                    Text("E-mail")
                        .bold()
                        .foregroundStyle(Color(.gray))
                    Text(client.email)
                }
                .font(.footnote)
                
                NavigationLink {
                    ClientMoreInfoView(client: client)

                } label: {
                    Text("Mais informações")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
                
                HStack {
                    Button {
                        mailManager.showMailComposer()
                    } label: {
                        Text("Enviar e-mail")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        requestDocument.toggle()
                    } label: {
                        Text("Solicitar documentos")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            Spacer()
        }
        .onChange(of: deleted) { change in
            dismiss()
        }
        .sheet(isPresented: $requestDocument, content: {
            RequestDocumentsView(client: client)
        })
        .sheet(isPresented: $editClient, content: {
            EditClientView(client: client, deleted: $deleted)
        })
        .padding()
    }
}
