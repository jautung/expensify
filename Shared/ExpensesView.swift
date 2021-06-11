import SwiftUI

struct ExpensesView: View {
    @ObservedObject var expensifyData: ExpensifyData
    @State var inspectExpenseShowAlert: Bool = false
    @State var inspectExpenseId: String = ""
    @State var deleteExpenseShowAlert: Bool = false
    @State var deleteExpenseId: String = ""

    var body: some View {
        let expenses = expensifyData.getExpensesReverseChrono()
        ZStack {
            BackgroundView()
            VStack {
                HStack {
                    H1Text(text: "Expenses")
                    Button(action: {
                        EmailHelper.shared.sendEmail(subject: "Expensify Data", body: expensifyData.getFullDataExport(), to: [])
                    }) { SystemImage(name: "square.and.arrow.down", size: 25) }
                }
                ScrollView(showsIndicators: true) {
                    VStack {
                        ForEach(expenses.indices, id: \.self) { expenseIndex in
                            CustomDivider(size: 2)
                            HStack {
                                Spacer()
                                Button(action: {
                                    inspectExpenseId = expenses[expenseIndex].id
                                    inspectExpenseShowAlert = true
                                }) {
                                    PText(text: expenseDisplayFormatter(expense: expenses[expenseIndex]))
                                        .frame(width: 320, height: 20, alignment: .leading)
                                }
                                Button(action: { // delete button
                                    deleteExpenseId = expenses[expenseIndex].id
                                    deleteExpenseShowAlert = true
                                }) { SystemImage(name: "xmark.circle.fill", size: 15) }
                                Spacer(minLength: 5)
                            }
                        }
                        CustomDivider(size: 2)
                    }
                }
                Spacer() // flushes VStack to the top
            }
            if inspectExpenseShowAlert {
                AlertControlView(
                    showAlert: $inspectExpenseShowAlert,
                    title: expenseDetailedFormatterTitle(expense: expensifyData.getExpense(id: inspectExpenseId)),
                    message: expenseDetailedFormatterMessage(expense: expensifyData.getExpense(id: inspectExpenseId)),
                    confirmation: nil,
                    placeholder: nil,
                    submitCallback: { _ in }
                )
            }
            if deleteExpenseShowAlert {
                AlertControlView(
                    showAlert: $deleteExpenseShowAlert,
                    title: "Delete Expense of $\(expensifyData.getExpense(id: deleteExpenseId).amount)?",
                    message: "Warning: This deletion is irreversible!",
                    confirmation: "Delete",
                    placeholder: nil,
                    submitCallback: { _ in
                        expensifyData.deleteExpense(id: deleteExpenseId)
                    }
                )
            }
        }
    }
    
    func expenseDisplayFormatter(expense: Expense) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y (E) h:mma"
        return "\(formatter.string(from: expense.date)): $\(String(format: "%.2f", expense.amount)) (\(expensifyData.getCategory(id: expense.categoryId)))"
    }

    func expenseDetailedFormatterTitle(expense: Expense) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y (E) h:mma"
        return "\(formatter.string(from: expense.date))"
    }

    func expenseDetailedFormatterMessage(expense: Expense) -> String {
        return "\nAmount: $\(String(format: "%.2f", expense.amount)) (\(expense.currency))\n\nCategory: \(expensifyData.getCategory(id: expense.categoryId))" + (expense.remarks != "" ? "\n\nRemarks: \(expense.remarks)" : "")
    }
}
