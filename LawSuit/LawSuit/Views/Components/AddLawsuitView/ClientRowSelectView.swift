//
//  ClientRowView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 02/10/24.
//

import SwiftUI

struct ClientRowSelectView: View {
    
    @EnvironmentObject var dataViewModel: DataViewModel
    
    @Binding var clientRowState: ClientRowStateEnum
    @Binding var lawsuitAuthorOrDefendantName: String
    
    @State var client: Client?
    @State var nsImage: NSImage?
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.tertiary.opacity(0.2))
               .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
        )

            
            if clientRowState == .selected {
                HStack{
                    if let nsImage {
                        Image(nsImage: nsImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.secondary.opacity(0.08))
                            .clipShape(Circle())
                    }
                    Text("\(lawsuitAuthorOrDefendantName)")
                    Spacer()
                    Button {
                        withAnimation {
                            lawsuitAuthorOrDefendantName = ""
                            clientRowState = .notSelected
                        }
                    } label: {
                        Image(systemName: "minus")
                    }
                }
                .padding( 5)
                
            } else if clientRowState == .notSelected {
                ClientRowNotSelectView()
            }
        }
        .onChange(of: lawsuitAuthorOrDefendantName) { newValue in
            self.client = dataViewModel.coreDataManager.clientManager.fetchFromName(name: lawsuitAuthorOrDefendantName)
            if let client = client {
                self.nsImage = NSImage(data: client.photo ?? Data())
            }
        }
        .frame(width: 218, height: 53)
    }
}

//#Preview {
//    ClientRowView( lawsuitAuthorName: .constant("Hey"))
//}

enum ClientRowStateEnum: String {
    case selected
    case notSelected
}
