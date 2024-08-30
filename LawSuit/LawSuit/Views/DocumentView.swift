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
    
    var body: some View {
        VStack {
            ClientInfoView(client: client)
            Divider()
            DocumentGridView()
                .padding()
        }
    }
}

