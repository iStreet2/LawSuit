//
//  EditProcessAuthorComponent.swift
//  LawSuit
//
//  Created by Emily Morimoto on 23/08/24.
//

import SwiftUI

struct EditProcessAuthorComponent: View {
    
    @State var choosedClient: String = ""

    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Autor")
                    .bold()
                Button(action: {
                    ClientCheckboxIconComponent(choosedClient: $choosedClient)
                    
                }, label: {
                    Text("Alterar cliente")
                })
                .buttonStyle(.borderless)
                .foregroundStyle(.blue)
            }
            Text(choosedClient)
        }
        
    }
}

#Preview {
    EditProcessAuthorComponent()
}
