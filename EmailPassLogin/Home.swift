import SwiftUI
import FirebaseAuth

struct Home: View {
    @State private var err: String = ""
    @State private var isSidebarVisible: Bool = false

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        isSidebarVisible.toggle()
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                    .padding()

                    Spacer()

//                    Text(
//                        "Notes"
//                    )
//                    .font(.headline)
                }
                
                NotesView()
                
//                Button {
//                    Task {
//                        do {
//                            try await Authentication().logout()
//                        } catch let e {
//                            err = e.localizedDescription
//                        }
//                    }
//                } label: {
//                    Text("Log Out").padding(8)
//                }
//                .buttonStyle(.borderedProminent)
                
                Text(err).foregroundColor(.red).font(.caption)
            }

            if isSidebarVisible {
                SideMenu(isSidebarVisible: $isSidebarVisible)
            }
        }
    }
}

