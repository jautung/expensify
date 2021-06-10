import SwiftUI

struct MainView: View {
    @State var selectedTab: Int = 1 // default second tab (add expense)
    @State var categories: Array<String> = [
        "Food",
        "Household use",
        "Local transport",
        "Long-distance transport",
        "Social"
    ]
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color("TabColor"))
    }

    var body: some View {
        TabView(selection:$selectedTab) {
            CategoriesView(categories: $categories).tabItem {
                Label("Categories", systemImage: "shippingbox.fill")
            }.tag(0)
            FormView(categories: $categories).tabItem {
                Label("Add", systemImage: "plus.circle.fill")
            }.tag(1)
            TrendView().tabItem {
                Label("Trends", systemImage: "arrow.up.arrow.down")
            }.tag(2)
            ChartView().tabItem {
                Label("Breakdown", systemImage: "chart.pie.fill")
            }.tag(3)
        }.preferredColorScheme(.light)
    }
}
