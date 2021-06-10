import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 0.7, green: 0.8, blue: 0.9).ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
