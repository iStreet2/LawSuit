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
            VStack(alignment: .leading) {
                Divider()
                Text(folderViewModel.getFolderPath())
                    .font(.headline)
                    .foregroundStyle(Color(.gray))
            }
        }
    }
}
