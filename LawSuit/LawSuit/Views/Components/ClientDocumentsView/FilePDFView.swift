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
    var geometry: GeometryProxy
    
    //MARK: ViewModels
    @EnvironmentObject var dragAndDropViewModel: DragAndDropViewModel
    @EnvironmentObject var folderViewModel: FolderViewModel

    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest var filesPDF: FetchedResults<FilePDF>
    
    init(parentFolder: Folder, geometry: GeometryProxy) {
        
        self.parentFolder = parentFolder
        self.geometry = geometry
        
        _filesPDF = FetchRequest<FilePDF>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "parentFolder == %@", parentFolder)
        )
    }
    
    var body: some View {
        ForEach(Array(filesPDF.enumerated()), id: \.offset) { index, file in
            FilePDFIconView(filePDF: file, parentFolder: parentFolder)
                .background(Color(index % 2 == 0 ? .gray : .white).opacity(0.1))
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
