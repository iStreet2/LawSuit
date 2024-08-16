//
//  SearchBarCheckboxComponent.swift
//  LawSuit
//
//  Created by Emily Morimoto on 15/08/24.
//

import SwiftUI

struct SearchBarCheckboxComponent: View {
    
    @Binding var searchText: String
    
    @State var active = true
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Search", text: $searchText, onEditingChanged: { editing in
                    withAnimation {
                        active = editing
                        active.toggle()
                    }
                })
            }
            .padding(7)
            .frame(width: 330, height: 36)
            .cornerRadius(10)
            
            if active == false {
                Button("Cancel") {
                    withAnimation {
                        active.toggle()
                    }
                }
            }
        }

    }

}


//#Preview {
//    SearchBarCheckboxComponent(searchText: Search)
//}
