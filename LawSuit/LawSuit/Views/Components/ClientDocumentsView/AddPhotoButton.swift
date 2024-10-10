//
//  AddPhotoButton.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 09/10/24.
//

import Foundation
import SwiftUI

struct AddPhotoButton: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 19)
            .stroke(Color.black, lineWidth: 1)
            .frame(width: 134, height: 134)
            .overlay {
                Image(systemName: "person.crop.rectangle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 29.49)
                    .foregroundColor(.secondary)
            }
    }
}

#Preview {
    AddPhotoButton()
}
