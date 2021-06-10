import SwiftUI

class ExpensifyData: ObservableObject {
    @Published var categories: Array<(id: String, name: String)> = []
    @Published var expenses: Array<(id: String, date: Date, amount: Float, currency: String, categoryId: String, remarks: String)> = []
    
    func addCategory(newName: String) {
        let uuid = UUID().uuidString
        categories.append((id: uuid, name: newName))
    }

    func editCategory(id: String, newName: String) {
        for categoryIndex in 0..<categories.count {
            if categories[categoryIndex].id == id {
                categories[categoryIndex] = (id: id, name: newName)
                return
            }
        }
    }

    func deleteCategory(id: String) {
        for categoryIndex in 0..<categories.count {
            if categories[categoryIndex].id == id {
                categories.remove(at: categoryIndex)
                return
            }
        }
    }
    
    func getCategories() -> Array<(id: String, name: String)> {
        return categories
    }

    func getCategoryIds() -> Array<String> {
        var categoryIds: Array<String> = []
        for categoryIndex in 0..<categories.count {
            categoryIds.append(categories[categoryIndex].id)
        }
        return categoryIds
    }

    func getCategory(id: String) -> String {
        if id == "__OTHERS__" { return "Others" }
        for categoryIndex in 0..<categories.count {
            if categories[categoryIndex].id == id {
                return categories[categoryIndex].name
            }
        }
        return ""
    }

    func getCategoryCount(id: String) -> Int { // number of expenses under that category
        var count: Int = 0
        for expenseIndex in 0..<expenses.count {
            if expenses[expenseIndex].categoryId == id {
                count += 1
            }
        }
        return count
    }

    func addExpense(date: Date, amount: Float, currency: String, categoryId: String, remarks: String) {
        let uuid = UUID().uuidString
        expenses.append((id: uuid, date: date, amount: amount, currency: currency, categoryId: categoryId, remarks: remarks))
    }
    
    func deleteExpense(id: String) {
        for expenseIndex in 0..<expenses.count {
            if expenses[expenseIndex].id == id {
                expenses.remove(at: expenseIndex)
                return
            }
        }
    }
    
    func getExpenses() -> Array<(id: String, date: Date, amount: Float, currency: String, categoryId: String, remarks: String)> {
        return expenses
    }

    func getExpense(id: String) -> (id: String, date: Date, amount: Float, currency: String, categoryId: String, remarks: String) {
        for expenseIndex in 0..<expenses.count {
            if expenses[expenseIndex].id == id {
                return expenses[expenseIndex]
            }
        }
        return (id: "", date: Date(), amount: 0.0, currency: "", categoryId: "", remarks: "")
    }
}
