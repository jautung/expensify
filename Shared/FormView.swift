import SwiftUI

struct FormView: View {
    @Binding var categories: Array<String>
    @State var date: Date = Date()
    @State var amount: String = ""
    @State var category = "Select a category"
    @State var remarks: String = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                VStack {
                    H1Text(text: "Add a New Expense")
                    CustomDivider()
                }

                VStack {
                    H2Text(text: "Date & Time")
                    DatePicker(selection: $date, label: { EmptyView() }).labelsHidden()
                    CustomDivider()
                }

                VStack {
                    H2Text(text: "Amount")
                    TextField("$1.00", text: $amount)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    CustomDivider()
                }

                VStack {
                    H2Text(text: "Category")
                    Picker("Category: \(category)", selection: $category) {
                        ForEach(categories + ["Others"], id: \.self) {
                            Text($0).foregroundColor(.black)
                        }
                    }.pickerStyle(MenuPickerStyle())
                    CustomDivider()
                }
                
                VStack {
                    H2Text(text: "Remarks")
                    TextField("Remarks", text: $remarks)
                        .multilineTextAlignment(.center).foregroundColor(.black)
                    CustomDivider()
                }
                
                CustomButton(text: "Submit", callback: {
                    print("Submit")
                })
                
                Spacer() // flushes VStack to the top
            }
        }
    }
}
