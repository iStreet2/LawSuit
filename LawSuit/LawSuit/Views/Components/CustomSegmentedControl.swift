//
//  CustomSegmentedControl.swift
//  LawSuit
//
//  Created by Giovanna Micher on 27/08/24.
//

import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var selectedOption: String
    var infos: [String]
    let color = Color("segmentedControl")
    @State var isHovering: Bool = false
    @State var hoveringIndex: Int?
    
    var body: some View {
        HStack(spacing: 0){
            ForEach(infos.indices, id:\.self) { index in
                if selectedOption == infos[index] {
                    Text(infos[index])
                        .font(.body)
                        .foregroundStyle(.red)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .background{
                            RoundedRectangle(cornerRadius: 3)
                                .foregroundStyle(.red.opacity(0.3))
                                
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(.black.opacity(0.05), lineWidth: 0.3)
                        }
                } else {
                    Text(infos[index])
                        .font(.body)
                        .foregroundStyle(.gray)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .background{
                            if hoveringIndex == index {
                                RoundedRectangle(cornerRadius: 3)
                                    .foregroundStyle(.black.opacity(0.05))
                            } else{
                                RoundedRectangle(cornerRadius: 3)
                                    .foregroundStyle(.clear)
                            }
                                
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(.clear, lineWidth: 0.3)
                        }
                        .onTapGesture(){
                            withAnimation(.easeInOut(duration: 0.1)) {
                                selectedOption = infos[index]
                            }
                            
                        }
                        .onHover { bool in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isHovering = bool
                                if isHovering {
                                    hoveringIndex = index
                                } else {hoveringIndex = nil}
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

//#Preview {
//    VStack{
//        CustomSegmentedControl()
//            .padding()
//            .background(.white)
//
//    }
//    //   @State var selectedOption = 0
////    return VStack{CustomSegmentedControl(selectedOption: $selectedOption, options: ["Processos","Documentos"])}.padding().background(.white)
//}
