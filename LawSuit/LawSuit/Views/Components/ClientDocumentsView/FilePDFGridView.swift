//
//  FilePDFGridView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//

import SwiftUI

struct FilePDFGridView: View {
    
    
    //MARK: Variáveis
    @ObservedObject var parentFolder: Folder
    @State var selectedFilePDF: FilePDF?
    @State var showPDF = false
    var geometry: GeometryProxy
    
    //MARK: ViewModels
    @EnvironmentObject var dragAndDropViewModel: DragAndDropViewModel
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
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
        ForEach(filesPDF, id: \.self) { file in
            FilePDFIconView(filePDF: file, parentFolder: parentFolder)
                .onTapGesture(count: 2) {
                    selectedFilePDF = file
                    showPDF.toggle()
                }
                .padding(.leading)
                .offset(x: dragAndDropViewModel.filePDFOffsets[file.id!]?.width ?? 0, y: dragAndDropViewModel.filePDFOffsets[file.id!]?.height ?? 0)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            dragAndDropViewModel.onDragChangedFilePDF(gesture: gesture, filePDF: file, geometry: geometry)
                        }
                        .onEnded { _ in
                            if let destinationFolder = dragAndDropViewModel.onDragEndedFilePDF(filePDF: file, context: context) {
                                withAnimation(.easeIn) {
                                    coreDataViewModel.filePDFManager.moveFilePDF(parentFolder: parentFolder, movingFilePDF: file, destinationFolder: destinationFolder)
                                    dragAndDropViewModel.filePDFOffsets[file.id!] = .zero
                                }
                            } else {
                                withAnimation(.bouncy) {
                                    dragAndDropViewModel.filePDFOffsets[file.id!] = .zero
                                }
                            }
                        }
                )
                .onAppear {
                    let frame = geometry.frame(in: .global)
                    dragAndDropViewModel.filePDFFrames[file.id!] = frame
                }
                .onChange(of: geometry.frame(in: .global)) { newFrame in
                    dragAndDropViewModel.filePDFFrames[file.id!] = newFrame
                }
                .sheet(isPresented: $showPDF, content: {
                    OpenFilePDFView(selectedFile: $selectedFilePDF)
                })
        }
    }
}