//
//  FolderIconView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//
// icone das pastas em grid

import SwiftUI
import Foundation

struct FolderIconView: View {
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var dragAndDropViewModel: DragAndDropViewModel
    
    //MARK: Variáveis de estado
    @ObservedObject var folder: Folder
    @ObservedObject var parentFolder: Folder
    @FocusState private var isTextFieldFocused: Bool
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        Group {
            if folderViewModel.showingGridView {
                VStack {
                    Image("Pasta")
                        .resizable()
                        .frame(width: 73, height: 58)
                        .frame(width: 85, height: 73)
                        .background(folder.isSelected ? Color.gray.opacity(0.2) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 5))

                    if folder.isEditing {
                        TextField("", text: Binding(
                            get: { folder.name },
                            set: { newValue in
                                folder.name = newValue
                            }
                        ), onCommit: {
                            saveChanges()
                        })
                        .focused($isTextFieldFocused)
                        .lineLimit(2)
                        .frame(height: 12)
                        .onAppear {
                            isTextFieldFocused = true
                            DispatchQueue.main.async {
                                selectAllTextInTextField()
                            }
                        }
                    } else {
                        Text(folder.name)
                            .lineLimit(1)
                            .onTapGesture(count: 2) {
                                folder.isEditing = true
                            }
                    }
                }
                
                
            } else {
                HStack {
                    Image("Pasta")
                        .resizable()
                        .frame(width: 18, height: 14)
                    
                    if folder.isEditing {
                        TextField("", text: Binding(
                            get: { folder.name },
                            set: { newValue in
                                folder.name = newValue
                            }
                        ), onCommit: {
                            saveChanges()
                        })
                        .lineLimit(2)
                        .frame(width: 120, height: 12)
                        .onAppear {
                            isTextFieldFocused = true
                            DispatchQueue.main.async {
                                selectAllTextInTextField()
                            }
                        }
                    } else {
                        Text(folder.name)
                            .lineLimit(1)
                            .onLongPressGesture {
                                folder.isEditing = true
                            }
                    }
                }
            }
        }
        //.border(.black)
        .onDisappear {
            folder.isEditing = false
        }
        .onDrag {
            dragAndDropViewModel.movingFolder = folder

            let tempDirectory = FileManager.default.temporaryDirectory
            let tempFolderURL = tempDirectory.appendingPathComponent(folder.name)
            
            do {
                try FileManager.default.createDirectory(at: tempFolderURL, withIntermediateDirectories: true, attributes: nil)
                dragAndDropViewModel.copyFolderContents(from: folder, to: tempFolderURL)
            } catch {
                print("Erro ao criar diretório temporário: \(error)")
            }
            return NSItemProvider(object: tempFolderURL as NSURL)
        }
    }
    
    func saveChanges() {
        dataViewModel.coreDataManager.folderManager.editFolderName(folder: folder, name: folder.name)
        folder.isEditing = false
    }
    
    func selectAllTextInTextField() {
        if let window = NSApplication.shared.windows.first,
           let textField = window.firstResponder as? NSTextField,
           let editor = textField.currentEditor() {
            editor.selectedRange = NSRange(location: 0, length: textField.stringValue.count)
        }
    }
}
