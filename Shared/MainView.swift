import SwiftUI

struct MainView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor.gray
    }

    var body: some View {
        TabView {
            FormView().tabItem {
                Label("Add", systemImage: "plus.circle.fill")
            }
            TrendView().tabItem {
                Label("Trends", systemImage: "arrow.up.arrow.down")
            }
            ChartView().tabItem {
                Label("Breakdown", systemImage: "chart.pie.fill")
            }
        }
    }
}

struct BackgroundView: View {
    var body: some View {
        Color(red: 0.7, green: 0.8, blue: 0.9).ignoresSafeArea()
    }
}

struct MainViewPreview: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
