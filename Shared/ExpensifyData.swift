import SwiftUI

struct Category: Codable {
    let id: String
    let name: String
}

struct Expense: Codable {
    let id: String
    let date: Date
    let amount: Float
    let currency: String
    let categoryId: String
    let remarks: String
}

final class ExpensifyData: ObservableObject, Codable {
    @Published var categories: Array<Category>
    @Published var expenses: Array<Expense>
    
    enum CodingKeys: CodingKey {
        case categories
        case expenses
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(categories, forKey: .categories)
        try container.encode(expenses, forKey: .expenses)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categories = try container.decode(Array<Category>.self, forKey: .categories)
        expenses = try container.decode(Array<Expense>.self, forKey: .expenses)
    }
    
    init(categories_: Array<Category>, expenses_: Array<Expense>) {
        categories = categories_
        expenses = expenses_
    }

    func addCategory(newName: String) {
        let uuid = UUID().uuidString
        categories.append(Category(id: uuid, name: newName))
        storeExpensifyData(expensifyData: self)
    }

    func editCategory(id: String, newName: String) {
        for categoryIndex in 0..<categories.count {
            if categories[categoryIndex].id == id {
                categories[categoryIndex] = Category(id: id, name: newName)
                storeExpensifyData(expensifyData: self)
                return
            }
        }
    }

    func deleteCategory(id: String) {
        for categoryIndex in 0..<categories.count {
            if categories[categoryIndex].id == id {
                categories.remove(at: categoryIndex)
                storeExpensifyData(expensifyData: self)
                return
            }
        }
    }
    
    func getCategories() -> Array<Category> {
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
        expenses.append(Expense(id: uuid, date: date, amount: amount, currency: currency, categoryId: categoryId, remarks: remarks))
        storeExpensifyData(expensifyData: self)
    }
    
    func deleteExpense(id: String) {
        for expenseIndex in 0..<expenses.count {
            if expenses[expenseIndex].id == id {
                expenses.remove(at: expenseIndex)
                storeExpensifyData(expensifyData: self)
                return
            }
        }
    }
    
    func getExpenses() -> Array<Expense> {
        return expenses
    }

    func getExpense(id: String) -> Expense {
        for expenseIndex in 0..<expenses.count {
            if expenses[expenseIndex].id == id {
                return expenses[expenseIndex]
            }
        }
        return Expense(id: "", date: Date(), amount: 0.0, currency: "", categoryId: "", remarks: "")
    }
}

func storeExpensifyData(expensifyData: ExpensifyData) {
    do {
        let encoder = JSONEncoder()
        let encodedExpensifyData = try encoder.encode(expensifyData)
        UserDefaults.standard.set(encodedExpensifyData, forKey: "expensifyData")
    } catch {
        print("unable to encode (\(error))")
    }
}

func loadExpensifyData() -> ExpensifyData {
    do {
        let decoder = JSONDecoder()
        let encodedExpensifyData = UserDefaults.standard.object(forKey: "expensifyData")
        if encodedExpensifyData == nil {
            return ExpensifyData(categories_: [], expenses_: [])
        } else {
            return try decoder.decode(ExpensifyData.self, from: encodedExpensifyData as! Data)
        }
    } catch {
        print("unable to decode (\(error))")
        return ExpensifyData(categories_: [], expenses_: [])
    }
}
