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
    @State var imageData: Data?

    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
   
 
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        HStack(alignment: .top) {
            if let photoData = client.photo,
               let nsImage = NSImage(data: photoData) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 80, height: 80)
                    .onTapGesture {
                        folderViewModel.importPhoto(imageData: $imageData)
                    }
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(client.name ?? "Cliente sem nome")
                        .font(.title)
                        .bold()
                    Text("\(client.age) anos")
                    //Botão de editar cliente, ainda nao temos a view
                    //            Button {
                    //                /
                    //            } label: {
                    //                Image(systemName: "square.and.pencil")
                    //                    .font(.system(size: 18))
                    //            }
                }
                NavigationLink {
                    //Tela que o paulo esta fazendo
                    TelaTemporariaDoPaulo()
                } label: {
                    Text("Mais informações")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())

            }
            Spacer()
        }
        .padding()
    }
}

//#Preview {
//    ClientInfoView()
//}
