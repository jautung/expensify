import SwiftUI
import CoreData

struct MainView: View {
    @State var testString: String = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Text("Hello World")
                TextField("Test", text: $testString, onEditingChanged: onEdit, onCommit: onCommit)
            }
        }
    }
    
    func onEdit(test: Bool) -> Void {
        print(test)
    }

    func onCommit() -> Void {
        print("commit")
    }
}

struct BackgroundView: View {
    var body: some View {
        Color(red: 0.7, green: 0.8, blue: 0.9).ignoresSafeArea()
    }
}

struct MainViewPreview: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
