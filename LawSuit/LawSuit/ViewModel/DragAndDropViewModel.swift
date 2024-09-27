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
                                    //id da pasta : posicao
    @Published var folderOffsets: [String: CGSize] = [:]
                                    //id : frame (quadrado invisivel p detectar colisao)
    @Published var folderFrames: [String: CGRect] = [:]
    @Published var filePDFOffsets: [String: CGSize] = [:]
    @Published var filePDFFrames: [String: CGRect] = [:]
    
    func onDragChangedFolder(gesture: DragGesture.Value, folder: Folder, geometry: GeometryProxy) {
        folderOffsets[folder.id!] = gesture.translation //cada pixel q eu ando, pega CGSize da posicao da folder
        let frame = geometry.frame(in: .global).offsetBy(dx: gesture.translation.width, dy: gesture.translation.height)
        folderFrames[folder.id!] = frame
    }
    
    func onDragChangedFilePDF(gesture: DragGesture.Value, filePDF: FilePDF, geometry: GeometryProxy) {
        filePDFOffsets[filePDF.id!] = gesture.translation
        let frame = geometry.frame(in: .global).offsetBy(dx: gesture.translation.width, dy: gesture.translation.height)
        filePDFFrames[filePDF.id!] = frame
    }
    
    
    func onDragEndedFolder(folder: Folder, context: NSManagedObjectContext) -> Folder? {
        var collisionDetected = false
        var destinationFolder: Folder?

        let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
        
        do {
            let folders = try context.fetch(fetchRequest)
            
            if let movingFolderFrame = folderFrames[folder.id!] {
                for (id, frame) in folderFrames {
                    if id != folder.id, frame.intersects(movingFolderFrame) {
                        if let destination = folders.first(where: { $0.id == id }) {
                            destinationFolder = destination
                        } else {
                            print("não encontrou a pasta destino")
                        }
                        collisionDetected = true
                        break
                    }
                }
            }
            
            if collisionDetected, let destination = destinationFolder {
                return destination
            } else {
                return nil
            }
        } catch {
            print("Erro ao realizar o fetch request: \(error)")
            return nil
        }
    }
    
    func onDragEndedFilePDF(filePDF: FilePDF, context: NSManagedObjectContext) -> Folder? {
        var collisionDetected = false
        var destinationFolder: Folder?

        let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
        
        do {
            let folders = try context.fetch(fetchRequest)
            
            if let movingFilePDfFrame = filePDFFrames[filePDF.id!] {
                for (id, frame) in folderFrames {
                    if id != filePDF.id!, frame.intersects(movingFilePDfFrame) {
                        if let destination = folders.first(where: { $0.id == id }) {
                            destinationFolder = destination
                        } else {
                            print("não encontrou a pasta destino")
                        }
                        collisionDetected = true
                        break
                    }
                }
            }
            
            if collisionDetected, let destination = destinationFolder {
                return destination
            } else {
                return nil
            }
        } catch {
            print("Erro ao realizar o fetch request: \(error)")
            return nil
        }
    }

    
    func updateFramesFolder(folders: FetchedResults<Folder>) {
        folderOffsets.removeAll()
        folderFrames.removeAll()

        DispatchQueue.main.async {
            for folder in folders {
                self.folderOffsets[folder.id!] = .zero
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let frame = self.folderFrames[folder.id!] {
                        self.folderFrames[folder.id!] = frame
                    }
                }
            }
        }
    }
    
    func updateFramesFilePDF(filesPDF: FetchedResults<FilePDF>) {
        filePDFOffsets.removeAll()
        filePDFFrames.removeAll()
        
        for filePDF in filesPDF {
            self.filePDFOffsets[filePDF.id!] = .zero
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let frame = self.filePDFFrames[filePDF.id!] {
                    self.filePDFFrames[filePDF.id!] = frame
                }
            }
        }
    }
    
    //MARK: para drag and drop externo, n tao sendo usadas!!
    
    func handleDrop(providers: [NSItemProvider], parentFolder: Folder, context: NSManagedObjectContext, dataViewModel: DataViewModel) {
        print("handleDrop: Iniciando o processamento do drop...")
        
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier("public.folder") {
                print("handleDrop: Encontrou uma pasta.")
                
                provider.loadFileRepresentation(forTypeIdentifier: "public.folder") { (url, error) in
                    if let error = error {
                        print("handleDrop: Erro ao carregar a pasta - \(error.localizedDescription)")
                    }
                    
                    if let url = url {
                        print("handleDrop: URL da pasta - \(url)")
                        self.processFolder(at: url, parentFolder: parentFolder, context: context, dataViewModel: dataViewModel)
                    } else {
                        print("handleDrop: Falha ao obter URL usando loadFileRepresentation.")
                    }
                }
            } else if provider.hasItemConformingToTypeIdentifier("public.file-url") {
                print("handleDrop: Encontrou um arquivo.")
                
                provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                    if let error = error {
                        print("handleDrop: Erro ao carregar o arquivo - \(error.localizedDescription)")
                    }
                    
                    if let data = urlData as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) {
                        print("handleDrop: URL do arquivo - \(url)")
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
            // Crie um ArquivoPDF e associe à pasta atual
            let filePDF = FilePDF(context: context)
            filePDF.id = UUID().uuidString
            filePDF.name = url.lastPathComponent
            filePDF.content = try? Data(contentsOf: url)
            filePDF.parentFolder = parentFolder

            // Adiciona o novo arquivo ao conjunto de arquivos da pasta pai
            parentFolder.addToFiles(filePDF)
            dataViewModel.coreDataManager.filePDFManager.saveContext()
        } else {
            print("Apenas arquivos PDF são suportados.")
        }
    }
    
    private func processFolder(at url: URL, parentFolder: Folder, context: NSManagedObjectContext, dataViewModel: DataViewModel) {
        print("processFolder: Iniciando o processamento da pasta - \(url.lastPathComponent)")
        
        let fileManager = FileManager.default
        // Crie uma nova instância de Pasta2
        let folder = Folder(context: context)
        folder.id = UUID().uuidString
        folder.name = url.lastPathComponent
        folder.parentFolder = parentFolder
        print("processFolder: Nova pasta criada - \(folder.name!)")

        if let contents = try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) {
            for item in contents {
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
        
        dataViewModel.coreDataManager.folderManager.saveContext()
        print("processFolder: Contexto salvo.")
    }
}
