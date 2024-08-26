//
//  LawSuitApp.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 09/08/24.
//

import SwiftUI

@main
struct LawSuitApp: App {
    
    @StateObject var coreDataViewModel = CoreDataViewModel()
    @StateObject var folderViewModel = FolderViewModel()
    @StateObject var dragAndDropViewModel = DragAndDropViewModel()
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
//            DocumentView()
            EditProcessAuthorComponent()
                .environment(\.managedObjectContext, coreDataViewModel.container.viewContext)
                .environmentObject(folderViewModel)
                .environmentObject(coreDataViewModel)
                .environmentObject(dragAndDropViewModel)
//            CheckboxView()
                .preferredColorScheme(.light)

        }
    }
}
