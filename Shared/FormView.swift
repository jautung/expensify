import SwiftUI

struct FormView: View {
    var frameworks = ["UIKit", "Core Data", "CloudKit", "SwiftUI"]
    @State var testString: String = ""
    @State var selectedFrameworkIndex: Int = 0
    @State var style: Int = 0
    @State var dateSelected: Date = Date()
    @State var selection = "Red"
    var colors = ["Red", "Green", "Blue", "Black", "Tartan"] // manually append Others
    @Binding var categories: Array<String>
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Text("Add a New Expense").font(.system(size: 36, weight: .bold)).foregroundColor(.black)

                FormLabel(text: "Date & Time")
                DatePicker("Date", selection: $dateSelected)

                FormLabel(text: "Amount")
                TextField("Test", text: $testString, onEditingChanged: onEdit, onCommit: onCommit)
                    .multilineTextAlignment(.center).foregroundColor(.black)

                FormLabel(text: "Category")
                Menu {
                    Button { style = 0 } label: { Text("Linear") }
                    Button { style = 1 } label: { Text("Radial") }
                } label: {
                    Text("\(style) Style").foregroundColor(.black)
                    Image(systemName: "arrowtriangle.down.fill").foregroundColor(.black)
                }

                Picker("Select a paint color (\(selection))", selection: $selection) {
                    ForEach(colors, id: \.self) {
                        Text($0).foregroundColor(.black)
                    }
                }.pickerStyle(MenuPickerStyle())

                FormLabel(text: "Remarks")
//                TextField("Test", text: $testString, onEditingChanged: onEdit, onCommit: onCommit)
//                    .multilineTextAlignment(.center).foregroundColor(.black)
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

struct FormLabel: View {
    var text: String
    var body: some View {
        Text(text).font(.system(size: 24, weight: .regular)).foregroundColor(.black)
    }
}
