import SwiftUI

struct ExpensesView: View {
    @ObservedObject var expensifyData: ExpensifyData
    @State var deleteExpenseShowAlert: Bool = false
    @State var deleteExpenseId: String = ""

    var body: some View {
        let expenses = expensifyData.getExpensesReverseChrono()
        ZStack {
            BackgroundView()
            VStack {
                H1Text(text: "Expenses")
                ScrollView(showsIndicators: true) {
                    VStack {
                        ForEach(expenses.indices, id: \.self) { expenseIndex in
                            CustomDivider(size: 2)
                            HStack {
                                Spacer()
                                PText(text: expenseFormatter(expense: expenses[expenseIndex])).frame(width: 320, height: 20, alignment: .leading)
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
    
    func expenseFormatter(expense: Expense) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y (E) h:mma"
        return "\(formatter.string(from: expense.date)): $\(String(format: "%.2f", expense.amount)) (\(expensifyData.getCategory(id: expense.categoryId)))"
    }
}
