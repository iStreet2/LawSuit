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

    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        HStack(alignment: .top) {
            //Foto do cliente
//            if let photoData = client.photo,
//               let nsImage = NSImage(data: photoData) {
//                Image(nsImage: nsImage)
//                    .resizable()
//                    .frame(width: 80, height: 80)
//                    .onTapGesture(count: 2) {
//                        withAnimation() {
//                            folderViewModel.importPhoto { data in
//                                if let data = data {
//                                    imageData = data
//                                    dataViewModel.coreDataManager.clientManager.addPhotoOnClient(client: client, photo: data)
//                                    client.photo = data
//                                }
//                            }
//                        }
//                    }
//            } else {
//                ZStack {
//                    Rectangle()
//                        .foregroundColor(.gray)
//                        .frame(width: 80, height: 80)
//                    Image(systemName: "square.and.arrow.down")
//                }
//                .onTapGesture(count: 2) {
//                    withAnimation {
//                        folderViewModel.importPhoto { data in
//                            if let data = data {
//                                imageData = data
//                                dataViewModel.coreDataManager.clientManager.addPhotoOnClient(client: client, photo: data)
//                            }
//                        }
//                    }
//                }
//            }
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
                    ClientMoreInfoView(client: client)

                } label: {
                    Text("Mais informações")
                        .font(.body)
                        .foregroundColor(.wine)
                        .underline()
                        .bold()
                }
                .buttonStyle(PlainButtonStyle())
                
                Button {
                    mailManager.showMailComposer()
                } label: {
                    Text("Enviar e-mail")
                        
                }
                .font(.title3)
                .buttonStyle(.borderedProminent)
                .tint(Color(.arqBlack))
                
            }
            Spacer()
        }
        .onChange(of: deleted) { change in
            dismiss()
        }
        .sheet(isPresented: $editClient, content: {
            EditClientView(client: client, deleted: $deleted)
        })
        .padding()
    }
}


//#Preview {
//    ClientInfoView()
//}
