import SwiftUI

struct MainView: View {
    @State var selectedTab: Int = 1 // default second tab (add expense)
    @ObservedObject var expensifyData: ExpensifyData = ExpensifyData()

    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color("TabColor"))
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            CategoriesView(expensifyData: expensifyData).tabItem {
                Label("Categories", systemImage: "shippingbox.fill")
            }.tag(0)
            FormView(expensifyData: expensifyData).tabItem {
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
