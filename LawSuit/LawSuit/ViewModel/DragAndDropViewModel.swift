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
    
    @Published var folderOffsets: [String: CGSize] = [:]
    @Published var folderFrames: [String: CGRect] = [:]
    @Published var filePDFOffsets: [String: CGSize] = [:]
    @Published var filePDFFrames: [String: CGRect] = [:]
    
    func onDragChanged(gesture: DragGesture.Value, folder: Folder, geometry: GeometryProxy) {
        folderOffsets[folder.id!] = gesture.translation
        let frame = geometry.frame(in: .global).offsetBy(dx: gesture.translation.width, dy: gesture.translation.height)
        folderFrames[folder.id!] = frame
    }
    
    func onDragEnded() {
        
    }
}
