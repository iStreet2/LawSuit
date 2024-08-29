//
//  ClientInfoView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 28/08/24.
//

import SwiftUI
import AppKit

struct ClientInfoView: View {
    
    //MARK: Variáveis de estado:
    @ObservedObject var client: Client
    @State var editClient = false
    @State var imageData: Data?

    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        HStack(alignment: .top) {
            if let photoData = client.photo,
               let nsImage = NSImage(data: photoData) {
                Image(nsImage: nsImage)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .onTapGesture(count: 2) {
                        withAnimation() {
                            folderViewModel.importPhoto { data in
                                if let data = data {
                                    imageData = data
                                    coreDataViewModel.clientManager.addPhotoOnClient(client: client, photo: data)
                                    client.photo = data
                                }
                            }
                        }
                    }
            } else {
                ZStack {
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: 80, height: 80)
                    Image(systemName: "square.and.arrow.down")
                }
                .onTapGesture(count: 2) {
                    withAnimation {
                        folderViewModel.importPhoto { data in
                            if let data = data {
                                imageData = data
                                coreDataViewModel.clientManager.addPhotoOnClient(client: client, photo: data)
                            }
                        }
                    }
                }
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(client.name)
                        .font(.title)
                        .bold()
                    Text("\(client.age) anos")
                    Button {
                        // Ação para editar o cliente
                        editClient.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 18))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                NavigationLink {
                    // Tela temporária
                    ClientMoreInfoView(client: client)
//                    TelaTemporariaDoPaulo()
                } label: {
                    Text("Mais informações")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())

            }
            Spacer()
        }
        .sheet(isPresented: $editClient, content: {
            EditClientView(client: client)
        })
        .padding()
    }
}


//#Preview {
//    ClientInfoView()
//}
