import SwiftUI
import AppKit


struct Teste: View {
    var body: some View {
        HStack {
            FirstSideBar()
            NavigationSplitView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Clientes")
                            .font(.title)
                            .bold()
                        Image(systemName: "plus")
                    }
                    List {
                        Text("Abigal")
                        Text("Bonito")
                    }
                }
                .padding()
                .background(.white)
            } detail: {
                Text("Hello World!")
            }
        }
    }
}

struct FirstSideBar: View {
    var body: some View {
        VStack(alignment: .trailing) {
            Image(systemName: "person.2")
                .padding(.bottom)
            Image(systemName: "briefcase")
            Spacer()
        }
        .listStyle(SidebarListStyle())
        .font(.title)
        .padding(20)
    }
}

#Preview {
    Teste()
        .preferredColorScheme(.light)
}
