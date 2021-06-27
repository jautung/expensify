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
    
    func getExpensesReverseChrono() -> Array<Expense> {
        return expenses.sorted { $0.date > $1.date }
    }
    
    func getExpenseFirstDate() -> Date {
        let expensesChrono = expenses.sorted { $0.date < $1.date }
        return expensesChrono.first!.date
    }

    func getExpenseLastDate() -> Date {
        let expensesChrono = expenses.sorted { $0.date < $1.date }
        return expensesChrono.last!.date
    }

    func getExpense(id: String) -> Expense {
        for expenseIndex in 0..<expenses.count {
            if expenses[expenseIndex].id == id {
                return expenses[expenseIndex]
            }
        }
        return Expense(id: "", date: Date(), amount: 0.0, currency: "", categoryId: "", remarks: "")
    }
    
    func getFullDataExport() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd/yyyy HH:mm:ss"

        var fullDataExport: String = "categoryId|name\n"
        for categoryIndex in 0..<categories.count {
            let category = categories[categoryIndex]
            fullDataExport += "\(category.id)|\(category.name)\n"
        }
        fullDataExport += "\nexpenseId|dateTime|amount|currency|categoryId|remarks\n"

        for expenseIndex in 0..<expenses.count {
            let expense = expenses[expenseIndex]
            fullDataExport += "\(expense.id)|\(formatter.string(from: expense.date))|\(expense.amount)|\(expense.currency)|\(expense.categoryId)|\(expense.remarks)\n"
        }
        return fullDataExport
    }
        
    func getTrendData(interval: String, categoryId: String) -> Array<(interval: String, amount: Float)> {
        if expenses.count <= 0 { return [] } // no data to get
        let dateFirst = getExpenseFirstDate()
        let dateLast = getExpenseLastDate()

        var dateIntervalStartComponents = DateComponents()
        dateIntervalStartComponents.hour = 0
        dateIntervalStartComponents.minute = 0
        dateIntervalStartComponents.second = 0
        dateIntervalStartComponents.nanosecond = 0
        switch interval {
        case "Daily":
            break
        case "Weekly", "Biweekly":
            dateIntervalStartComponents.weekday = 1
        case "Monthly":
            dateIntervalStartComponents.day = 1
        case "Yearly":
            dateIntervalStartComponents.day = 1
            dateIntervalStartComponents.month = 1
        default:
            print("error: invalid interval specification (\(interval))")
            return []
        }

        let dateStart: Date = Calendar.current.nextDate(after: dateFirst, matching: dateIntervalStartComponents, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward)!
        
        var dateIntervalStarts: Array<Date> = [dateStart]
        while dateIntervalStarts.last! <= dateLast {
            var dateNext: Date = Calendar.current.nextDate(after: dateIntervalStarts.last!, matching: dateIntervalStartComponents, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)!
            if interval == "Biweekly" {
                dateNext = Calendar.current.nextDate(after: dateNext, matching: dateIntervalStartComponents, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)!
            }
            dateIntervalStarts.append(dateNext)
        }

        var amounts: Array<Float> = Array(repeating: 0.0, count: dateIntervalStarts.count-1)
        for expenseIndex in 0..<expenses.count {
            let expense: Expense = expenses[expenseIndex]
            if categoryId != "__ALL__" && categoryId != expense.categoryId { continue }
            for dateIntervalIndex in 0..<amounts.count {
                if expense.date >= dateIntervalStarts[dateIntervalIndex] && expense.date < dateIntervalStarts[dateIntervalIndex+1] {
                    amounts[dateIntervalIndex] += convertToUsd(amount: expense.amount, currency: expense.currency)
                    break
                }
            }
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd/yyyy"
        
        var trendData: Array<(interval: String, amount: Float)> = []
        for dateIntervalIndex in 0..<amounts.count {
            trendData.append((interval: "\(formatter.string(from: dateIntervalStarts[dateIntervalIndex])) - \(formatter.string(from: dateIntervalStarts[dateIntervalIndex+1]))", amount: amounts[dateIntervalIndex]))
        }

        return trendData
    }
    
    func getTrendDataExport(interval: String, categoryId: String) -> String {
        let trendData = getTrendData(interval: interval, categoryId: categoryId)
        var trendDataExport: String = "interval|amount\n"
        for pointIndex in 0..<trendData.count {
            let point = trendData[pointIndex]
            trendDataExport += "\(point.interval)|\(point.amount)\n"
        }
        return trendDataExport
    }

    func getBreakdownData(startDate: Date, endDate: Date) -> Array<(categoryId: String, amount: Float)> {
        var amounts: Array<Float> = Array(repeating: 0.0, count: categories.count+1) // +1 for __OTHERS__
        for expenseIndex in 0..<expenses.count {
            let expense: Expense = expenses[expenseIndex]
            if expense.date < startDate || expense.date >= endDate { continue }
            if expense.categoryId == "__OTHERS__" {
                amounts[categories.count] += convertToUsd(amount: expense.amount, currency: expense.currency)
            } else {
                for categoryIndex in 0..<categories.count {
                    if categories[categoryIndex].id == expense.categoryId {
                        amounts[categoryIndex] += convertToUsd(amount: expense.amount, currency: expense.currency)
                        break
                    }
                }
            }
        }

        var breakdownData: Array<(categoryId: String, amount: Float)> = []
        for categoryIndex in 0..<amounts.count {
            breakdownData.append((categoryId: "\(categoryIndex == categories.count ? "__OTHERS__" : categories[categoryIndex].id)", amount: amounts[categoryIndex]))
        }

        return breakdownData
    }

    func getBreakdownDataExport(startDate: Date, endDate: Date) -> String {
        let breakdownData = getBreakdownData(startDate: startDate, endDate: endDate)
        var breakdownDataExport: String = "categoryId|category|amount\n"
        for pointIndex in 0..<breakdownData.count {
            let point = breakdownData[pointIndex]
            breakdownDataExport += "\(point.categoryId)|\(getCategory(id: point.categoryId))|\(point.amount)\n"
        }
        return breakdownDataExport
    }

    func convertToUsd(amount: Float, currency: String) -> Float {
        var exchangeRate: Float = 0.0 // dummy
        switch currency {
        case "USD":
            exchangeRate = 1.0
        case "SGD":
            exchangeRate = 0.76 // maybe switch to an API in the future
        default:
            print("error: unknown currency (\(currency))")
            break
        }
        return amount * exchangeRate
    }
}

// to retrieve backup .json files: https://stackoverflow.com/questions/38064042/access-files-in-var-mobile-containers-data-application-without-jailbreaking-iph
func storeExpensifyData(expensifyData: ExpensifyData) {
    do {
        let encoder = JSONEncoder()
        let encodedExpensifyData = try encoder.encode(expensifyData)
        try encodedExpensifyData.write(to: getExpensifyDataUrl(), options: [])
    } catch {
        print("unable to store expensify data (\(error))")
    }
}

func loadExpensifyData() -> ExpensifyData {
    do {
        let decoder = JSONDecoder()
        let encodedExpensifyData = try Data(contentsOf: getExpensifyDataUrl())
        let expensifyData = try decoder.decode(ExpensifyData.self, from: encodedExpensifyData)
        return expensifyData
    } catch {
        print("unable to load expensify data (\(error))")
        return ExpensifyData(categories_: [], expenses_: [])
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func getExpensifyDataUrl() -> URL {
    return getDocumentsDirectory().appendingPathComponent("expensifyData.json")
}
