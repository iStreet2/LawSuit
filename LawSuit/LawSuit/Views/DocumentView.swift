//
//  DocumentView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import SwiftUI
import CoreData

struct DocumentView: View {
    
    @EnvironmentObject var folderViewModel: FolderViewModel

    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var client: Client
    
    @State var deleted = false
    
    var body: some View {
        if deleted {
            Text("Selecione um cliente")
                .foregroundColor(.gray)
        } else {
            VStack {
                ClientInfoView(client: client, deleted: $deleted)
                Divider()
                DocumentGridView()
                    .padding()
            }
        }
    }
}

