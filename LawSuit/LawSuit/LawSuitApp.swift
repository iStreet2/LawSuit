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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//            DocumentView()
//            SelectClientView()
                .environment(\.managedObjectContext, coreDataViewModel.context)
                .environmentObject(folderViewModel)
                .environmentObject(coreDataViewModel)
        }
    }
}
