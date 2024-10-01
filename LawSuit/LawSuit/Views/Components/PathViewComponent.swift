//
//  PathViewComponent.swift
//  LawSuit
//
//  Created by Giovanna Micher on 27/09/24.
//

import SwiftUI

struct PathViewComponent: View {
    @EnvironmentObject var folderViewModel: FolderViewModel
    
    var body: some View {
        if folderViewModel.getPath().getItens().count != 1 {
            VStack(alignment: .leading, spacing: 0) {
                Divider()
                VStack(alignment: .leading, spacing: 0) {
                    Text(folderViewModel.getFolderPath())
                        .font(.footnote)
                        .bold()
                        .foregroundStyle(Color(.gray))
                        .padding(.vertical, 5.5)
                }
                .padding(.horizontal, 20)
                
            }
            .background(.quaternary.opacity(0.5))
        }
    }
}
