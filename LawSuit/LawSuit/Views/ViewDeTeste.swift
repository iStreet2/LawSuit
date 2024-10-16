import SwiftUI

struct ViewDeTeste: View {
    let items = ["Item 1", "Item 2", "Item 3", "Item 4"]

    var body: some View {
        VStack {
            ForEach(items.indices, id: \.self) { index in
                Text(items[index])
                    .background(GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                let coordinates = geo.frame(in: .global)
                                print("Coordinates of \(items[index]): \(coordinates)")
                            }
                    })
            }
        }
    }
}

#Preview {
    ViewDeTeste()
}
