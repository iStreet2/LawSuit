//
//  CustomSegmentedControl.swift
//  LawSuit
//
//  Created by Giovanna Micher on 27/08/24.
//

import SwiftUI

struct CustomSegmentedControl: View {
    @State var selectedOption: Int = 0
    var options: [String] = ["Processos","Documentos"]
    let color = Color("segmentedControl")
    @State var isHovering: Bool = false
    
    var body: some View {
        HStack(spacing: 0){
            ForEach(options.indices, id:\.self) { index in
                if selectedOption == index {
                    Text(options[index])
                        .foregroundStyle(.orange)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .background{
                            RoundedRectangle(cornerRadius: 3)
                                .foregroundStyle(.orange.opacity(0.3))
                                
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(.secondary, lineWidth: 0.3)
                        }
                } else {
                    Text(options[index])
                        .foregroundStyle(.gray)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .background{
                            RoundedRectangle(cornerRadius: 3)
                                .foregroundStyle(isHovering ? .black.opacity(0.05) : .clear)
                                
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(.clear, lineWidth: 0.3)
                        }
                        .onTapGesture(){
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedOption = index
                            }
                            
                        }
                        .onHover { bool in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isHovering = bool
                            }
                        }
                }

                    
            }
        }
        .padding(5)
        .background{
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(.black.opacity(0.05))
                
        }
        .overlay {
            RoundedRectangle(cornerRadius: 6)
                .stroke(.black.opacity(0.08), lineWidth: 0.5)
        }
        
       
        
    }
}

#Preview {
    VStack{
        CustomSegmentedControl()
            .padding()
            .background(.white)

    }
    //   @State var selectedOption = 0
//    return VStack{CustomSegmentedControl(selectedOption: $selectedOption, options: ["Processos","Documentos"])}.padding().background(.white)
}
