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
                
                Button {
                    showMailComposer()
                } label: {
                    Text("Enviar e-mail")
                }
                .buttonStyle(.borderedProminent)
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
    
    func showMailComposer() {
        let service = NSSharingService(named: NSSharingService.Name.composeEmail)
        service?.recipients = [client.email]
        service?.subject = "Test Mail"
        service?.perform(withItems: ["Test Mail body"])
    }
}


//#Preview {
//    ClientInfoView()
//}
