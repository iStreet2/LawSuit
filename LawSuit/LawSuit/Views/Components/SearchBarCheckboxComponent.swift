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
        
        Spacer()
        HStack {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.black)
                TextField("Search", text: $searchText, onEditingChanged: { editing in
                    withAnimation {
                        active = editing
                        active.toggle()
                        
                    }
    
                })
                .textFieldStyle(.plain)
                .onTapGesture {

                }
            }
            
            .padding(7)
//            .frame(width: 550, height: 36)
            .cornerRadius(10) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 7)
                    .stroke(.secondary, lineWidth: 0.3)
            )
            
//            if active == false {
//                Button("Cancel") {
//                    withAnimation {
//                        active.toggle()
//                    }
//                }
//            }
        }
    }

}

//#Preview {
//    CheckboxView()
//}
//
