import SwiftUI

struct FormView: View {
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
