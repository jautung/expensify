import SwiftUI

struct FormView: View {
    @ObservedObject var expensifyData: ExpensifyData
    @Binding var selectedTab: Int
    @State var date: Date = Date()
    @State var amount: String = ""
    @State var amountError: Bool = false
    @State var currency: String = "USD"
    @State var categoryId = ""
    @State var categoryError: Bool = false
    @State var remarks: String = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                VStack {
                    H1Text(text: "Add a New Expense")
                    CustomDivider(size: 10)
                }

                VStack {
                    H2Text(text: "Date & Time")
                    DatePicker(selection: $date, label: { EmptyView() }).labelsHidden()
                    CustomDivider(size: 10)
                }

                VStack {
                    if !amountError { H2Text(text: "Amount") } else { H2TextError(text: "Amount") }
                    HStack {
                        TextField("Amount", text: $amount)
                            .frame(width: 80, height: 40)
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                            .foregroundColor(.black)
                        CustomPicker(selectedItemId: $currency, itemIds: ["USD", "SGD"], displayer: { itemId in
                            return itemId
                        })
                    }
                    CustomDivider(size: 10)
                }

                VStack {
                    if !categoryError { H2Text(text: "Category") } else { H2TextError(text: "Category") }
                    CustomPicker(selectedItemId: $categoryId, itemIds: expensifyData.getCategoryIds() + ["__OTHERS__"], displayer: { itemId in
                        if itemId == "" { return "Select a category" }
                        else if itemId == "__OTHERS__" { return "Others" }
                        else { return expensifyData.getCategory(id: itemId) }
                    })
                    CustomDivider(size: 10)
                }
                
                VStack {
                    H2Text(text: "Remarks")
                    TextField("Remarks", text: $remarks)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    CustomDivider(size: 10)
                }
                
                CustomButton(text: "Submit", callback: {
                    amountError = !amountCheck(amount: amount)
                    categoryError = (categoryId == "")
                    if amountError || categoryError { return }
                    expensifyData.addExpense(date: date, amount: Float(amount)!, currency: currency, categoryId: categoryId, remarks: remarks)
                    date = Date()
                    amount = ""
                    categoryId = ""
                    remarks = ""
                    selectedTab = 2
                })

                Spacer() // flushes VStack to the top
            }
        }
    }
    
    func amountCheck(amount: String) -> Bool {
        if amount.count <= 0 { return false } // empty string
        if !CharacterSet(charactersIn: amount).isSubset(of: CharacterSet(charactersIn: ".0123456789")) { return false }
        if amount.filter({ $0 == "." }).count > 1 { return false }
        return true
    }
}
