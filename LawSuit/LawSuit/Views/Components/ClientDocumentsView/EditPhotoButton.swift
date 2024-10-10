//
//  EditPhotoButton.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 10/10/24.
//

import Foundation
import SwiftUI

struct EditPhotoButton: View {
    
    @State var image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: 134, height: 134)
            .overlay {
                ZStack {
                    Color.black
                        .opacity(0.6)
                    Image(systemName: "pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .foregroundStyle(.white)
                }
            }
    }
}

#Preview {
    EditPhotoButton(image: Image("miragna"))
}


