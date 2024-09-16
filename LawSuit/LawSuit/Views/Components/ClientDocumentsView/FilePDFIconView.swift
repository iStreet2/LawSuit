//
//  FilePDFIconView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//

import SwiftUI

struct FilePDFIconView: View {
    
    //MARK: Variáveis
    @ObservedObject var filePDF: FilePDF
    @ObservedObject var parentFolder: Folder
    @State var isEditing = false
    @State var fileName: String
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    
    init(filePDF: FilePDF, parentFolder: Folder) {
        self.filePDF = filePDF
        self.fileName = filePDF.name!
        self.parentFolder = parentFolder
        
    }
    
    var body: some View {
        VStack {
            Image(systemName: "doc")
                .font(.system(size: 55))
            if isEditing {
                TextField("", text: $fileName, onEditingChanged: { _ in
                    isEditing = true
                }, onCommit: {
                    saveChanges()
                })
                .onExitCommand(perform: cancelChanges)
                .lineLimit(1)
                .frame(height: 4)
            }
            else {
                Text(filePDF.name ?? "Sem nome")
                    .lineLimit(1)
                    .onTapGesture(count: 2) {
                        isEditing = true
                    }
            }
        }
        .onDisappear {
            isEditing = false
        }
        .onAppear {
            if fileName == "Novo Arquivo" {
                isEditing = true
            }
        }
        .contextMenu {
            Button(action: {
                //MARK: Fazer a view de visualizar um pdf ainda
                
            }) {
                Text("Abrir Arquivo")
                Image(systemName: "doc")
            }
            Button(action: {
                isEditing = true
            }) {
                Text("Renomear")
                Image(systemName: "pencil")
            }
            Button(action: {
                Task {
                    //MARK: CloudKit
                    try await dataViewModel.cloudManager.recordManager.deleteObjectInCloudKit(object: filePDF)
                    
                    //MARK: CoreData
                    withAnimation(.easeIn) {
                        dataViewModel.coreDataManager.filePDFManager.deleteFilePDF(parentFolder: parentFolder, filePDF: filePDF)
                    }
                }
            }) {
                Text("Excluir")
                Image(systemName: "trash")
            }
        }
//        .onDrag {
//            // Gera uma URL temporária para o PDF
//            let tempDirectory = FileManager.default.temporaryDirectory
//            let tempPDFURL = tempDirectory.appendingPathComponent(filePDF.name!)
//            
//            // Escreve os dados do PDF no local temporário
//            try? filePDF.content?.write(to: tempPDFURL)
//            
//            // Retorna o NSItemProvider com a URL do PDF temporário
//            return NSItemProvider(object: tempPDFURL as NSURL)
//        }
        
    }
    private func cancelChanges() {
        fileName = filePDF.name!
        isEditing = false
    }
    
    private func saveChanges() {
        //MARK: CoreData
        dataViewModel.coreDataManager.filePDFManager.editFilePDFName(filePDF: filePDF, name: fileName)
        
        //MARK: CloudKit
        let propertyNames = ["name"]
        let propertyValues: [Any] = [fileName]
        Task {
            try await dataViewModel.cloudManager.recordManager.updateObjectInCloudKit(object: filePDF, propertyNames: propertyNames, propertyValues: propertyValues)
        }
        isEditing = false
    }
}
