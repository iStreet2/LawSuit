//
//  FilePDFGridView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//

import SwiftUI

struct FilePDFView: View {
    
    //MARK: Variáveis
    @ObservedObject var parentFolder: Folder

    @State var selectedFilePDF: FilePDF?
    @State var showPDF = false
    
    //MARK: ViewModels
    @EnvironmentObject var dragAndDropViewModel: DragAndDropViewModel
    @EnvironmentObject var folderViewModel: FolderViewModel

    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest var filesPDF: FetchedResults<FilePDF>
    
    init(parentFolder: Folder) {
        self.parentFolder = parentFolder
        
        _filesPDF = FetchRequest<FilePDF>(
            sortDescriptors: [NSSortDescriptor(keyPath: \FilePDF.createdAt, ascending: true)],
            predicate: NSPredicate(format: "parentFolder == %@", parentFolder)
        )
    }
    
    var body: some View {
        ForEach(Array(filesPDF.enumerated()), id: \.offset) { index, file in
            FilePDFIconView(filePDF: file, parentFolder: parentFolder)
                .onTapGesture(count: 2) {
                    selectedFilePDF = file
                    showPDF.toggle()
                }
                .frame(maxWidth: .infinity, alignment: folderViewModel.showingGridView ? .center : .leading)
                .sheet(isPresented: $showPDF, content: {
                    OpenFilePDFView(selectedFile: $selectedFilePDF)
                })
        }
    }
}
