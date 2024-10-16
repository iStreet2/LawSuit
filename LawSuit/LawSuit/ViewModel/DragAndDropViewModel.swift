//
//  DragAndDropViewModel.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//

import Foundation
import CoreData
import SwiftUI

class DragAndDropViewModel: ObservableObject {
    
    @Published var movingFolder: Folder?
    @Published var movingFilePDF: FilePDF?
        
    func handleDrop(providers: [NSItemProvider], parentFolder: Folder, destinationFolder: Folder? = nil, context: NSManagedObjectContext, dataViewModel: DataViewModel) {
        print("handleDrop: Iniciando o processamento do drop...")
        
        // Verificar se o usuário está arrastando uma pasta de dentro do app
        if let movingFolder = movingFolder, let destinationFolder = destinationFolder {
            print("handleDrop: Movendo uma pasta interna.")
            if movingFolder != destinationFolder {
                // Mover pasta interna
                withAnimation(.bouncy) {
                    dataViewModel.coreDataManager.folderManager.moveFolder(parentFolder: parentFolder, movingFolder: movingFolder, destinationFolder: destinationFolder)
                    self.movingFolder = nil  // Resetar após a movimentação
                }
            }
            return
        }
        
        // Verificar se o usuário está arrastando um arquivo PDF de dentro do app
        if let movingFilePDF = movingFilePDF, let destinationFolder = destinationFolder {
            print("handleDrop: Movendo um arquivo PDF interno.")
            // Mover arquivo PDF interno
            withAnimation(.bouncy) {
                dataViewModel.coreDataManager.filePDFManager.moveFilePDF(parentFolder: parentFolder, movingFilePDF: movingFilePDF, destinationFolder: destinationFolder)
                self.movingFilePDF = nil  // Resetar após a movimentação
            }
            return
        }
        
        // Caso contrário, estamos lidando com um item externo (de fora do app)
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier("public.folder") {
                print("handleDrop: Encontrou uma pasta externa.")
                
                provider.loadFileRepresentation(forTypeIdentifier: "public.folder") { (url, error) in
                    if let error = error {
                        print("handleDrop: Erro ao carregar a pasta - \(error.localizedDescription)")
                    }
                    
                    if let url = url {
                        print("handleDrop: URL da pasta externa - \(url)")
                        self.processFolder(at: url, parentFolder: parentFolder, context: context, dataViewModel: dataViewModel)
                    } else {
                        print("handleDrop: Falha ao obter URL usando loadFileRepresentation.")
                    }
                }
            } else if provider.hasItemConformingToTypeIdentifier("public.file-url") {
                print("handleDrop: Encontrou um arquivo externo.")
                
                provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                    if let error = error {
                        print("handleDrop: Erro ao carregar o arquivo - \(error.localizedDescription)")
                    }
                    
                    if let data = urlData as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) {
                        print("handleDrop: URL do arquivo externo - \(url)")
                        self.processFile(at: url, parentFolder: parentFolder, context: context, dataViewModel: dataViewModel)
                    } else {
                        print("handleDrop: Falha ao converter urlData para URL.")
                    }
                }
            } else {
                print("handleDrop: Tipo de item desconhecido ou não suportado.")
            }
        }
    }

    
    private func processFile(at url: URL, parentFolder: Folder, context: NSManagedObjectContext, dataViewModel: DataViewModel) {
        if url.pathExtension == "pdf" {
            withAnimation(.bouncy) {
                // Crie um ArquivoPDF e associe à pasta atual
                let filePDF = FilePDF(context: context)
                filePDF.id = UUID().uuidString
                filePDF.name = url.lastPathComponent
                filePDF.content = try? Data(contentsOf: url)
                filePDF.parentFolder = parentFolder
                
                // Adiciona o novo arquivo ao conjunto de arquivos da pasta pai
                parentFolder.addToFiles(filePDF)
            }
            dataViewModel.coreDataManager.filePDFManager.saveContext()
        } else {
            print("Apenas arquivos PDF são suportados.")
        }
    }
    
    private func processFolder(at url: URL, parentFolder: Folder, context: NSManagedObjectContext, dataViewModel: DataViewModel) {
        print("processFolder: Iniciando o processamento da pasta - \(url.lastPathComponent)")
        
        withAnimation(.bouncy) {
            
            let fileManager = FileManager.default
            // Crie uma nova instância de Pasta2
            let folder = Folder(context: context)
            folder.id = UUID().uuidString
            folder.name = url.lastPathComponent
            folder.parentFolder = parentFolder
            print("processFolder: Nova pasta criada - \(folder.name!)")
            
            if let contents = try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) {
                for item in contents {
                    // Ignorar arquivos .DS_Store
                    if item.lastPathComponent == ".DS_Store" {
                        print("processFolder: Ignorando arquivo .DS_Store.")
                        continue
                    }
                    
                    if item.pathExtension == "pdf" {
                        print("processFolder: Encontrou um PDF - \(item.lastPathComponent)")
                        processFile(at: item, parentFolder: folder, context: context, dataViewModel: dataViewModel)
                    } else if fileManager.fileExists(atPath: item.path, isDirectory: nil) {
                        print("processFolder: Encontrou uma subpasta - \(item.lastPathComponent)")
                        processFolder(at: item, parentFolder: folder, context: context, dataViewModel: dataViewModel)
                    } else {
                        print("processFolder: Arquivo não suportado - \(item.lastPathComponent)")
                    }
                }
            } else {
                print("processFolder: Não foi possível acessar o conteúdo da pasta.")
            }
            
            parentFolder.addToFolders(folder)
        }
        dataViewModel.coreDataManager.folderManager.saveContext()
        print("processFolder: Contexto salvo.")
    }
    
    func copyFolderContents(from folder: Folder, to destinationURL: URL) {
        let fileManager = FileManager.default
        
        // Copia os arquivos PDF da pasta
        if let files = folder.files as? Set<FilePDF> {
            for file in files {
                if let fileContent = file.content {
                    let fileURL = destinationURL.appendingPathComponent(file.name ?? "Arquivo.pdf")
                    do {
                        try fileContent.write(to: fileURL)
                        print("Arquivo copiado para \(fileURL)")
                    } catch {
                        print("Erro ao copiar arquivo \(file.name ?? ""): \(error)")
                    }
                }
            }
        }

        // Copia as subpastas da pasta
        if let subfolders = folder.folders as? Set<Folder> {
            for subfolder in subfolders {
                let subfolderURL = destinationURL.appendingPathComponent(subfolder.name ?? "Subpasta")
                do {
                    try fileManager.createDirectory(at: subfolderURL, withIntermediateDirectories: true, attributes: nil)
                    // Recursivamente copia o conteúdo das subpastas
                    copyFolderContents(from: subfolder, to: subfolderURL)
                } catch {
                    print("Erro ao criar subpasta temporária \(subfolder.name ?? ""): \(error)")
                }
            }
        }
    }
}
