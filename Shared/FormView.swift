import SwiftUI

struct FormView: View {
    @Binding var categories: Array<String>
    @State var date: Date = Date()
    @State var amount: String = ""
    @State var amountError: Bool = false
    @State var currency: String = "USD"
    @State var category = "Select a category"
    @State var categoryError: Bool = false
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
                    if !amountError { H2Text(text: "Amount") } else { H2TextError(text: "Amount") }
                    HStack {
                        TextField("Amount", text: $amount)
                            .frame(width: 80, height: 40)
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                            .foregroundColor(.black)
                        CustomPicker(selectedItem: $currency, items: ["USD", "SGD"])
                    }
                    CustomDivider()
                }

                VStack {
                    if !categoryError { H2Text(text: "Category") } else { H2TextError(text: "Category") }
                    CustomPicker(selectedItem: $category, items: categories + ["Others"])
                    CustomDivider()
                }
                
                VStack {
                    H2Text(text: "Remarks")
                    TextField("Remarks", text: $remarks)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    CustomDivider()
                }
                
                CustomButton(text: "Submit", callback: {
                    amountError = !amountCheck(amount: amount)
                    categoryError = (category == "Select a category")
                    if amountError || categoryError { return }
                    print(date, amount, currency, category, remarks)
                })

                Spacer() // flushes VStack to the top
            }
        }
    }
    
    func amountCheck(amount: String) -> Bool {
        if amount.count <= 0 { return false }
        if !CharacterSet(charactersIn: amount).isSubset(of: CharacterSet(charactersIn: ".0123456789")) { return false }
        var periodCount = 0
        for char in amount {
            if char == "." {
                periodCount += 1
                if periodCount >= 2 { return false }
            }
        }
        return true
    }
}
