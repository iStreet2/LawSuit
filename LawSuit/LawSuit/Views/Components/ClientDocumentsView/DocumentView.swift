//
//  DocumentView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 11/09/24.
//

import Foundation
import SwiftUI

struct DocumentView: View{
    var body: some View{
        HStack{
            Button(action: {
                DocumentGridView()
            }, label: {
                Image(systemName: "square.grid.2x2")
            })
            Button(action: {
                DocumentListView()
            }, label: {
                Image(systemName: "list.bullet")
            })
        }
    }
}

#Preview {
    DocumentView()
}
