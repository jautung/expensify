import SwiftUI

struct MainView: View {
    @ObservedObject var expensifyData: ExpensifyData
    @State var selectedTab: Int = 1 // default second tab (add expense)

    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color("TabColor"))
        expensifyData = loadExpensifyData()
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            CategoriesView(expensifyData: expensifyData).tabItem {
                Label("Categories", systemImage: "shippingbox.fill")
            }.tag(0)
            FormView(expensifyData: expensifyData, selectedTab: $selectedTab).tabItem {
                Label("Add", systemImage: "plus.circle.fill")
            }.tag(1)
            ExpensesView(expensifyData: expensifyData).tabItem {
                Label("Expenses", systemImage: "dollarsign.circle.fill")
            }.tag(2)
            TrendView(expensifyData: expensifyData).tabItem {
                Label("Trends", systemImage: "arrow.up.arrow.down")
            }.tag(3)
            ChartView(expensifyData: expensifyData).tabItem {
                Label("Breakdown", systemImage: "chart.pie.fill")
            }.tag(4)
        }.preferredColorScheme(.light)
    }
}
