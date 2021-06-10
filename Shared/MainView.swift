import SwiftUI
import CoreData

struct MainView: View {
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

struct MainViewPreview: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct FormView: View {
    @State var testString: String = ""
    
    var body: some View {
        VStack {
            Text("Hello World")
            TextField("Test", text: $testString, onEditingChanged: onEdit, onCommit: onCommit)
        }
    }

    func onEdit(test: Bool) -> Void {
        print(test)
    }

    func onCommit() -> Void {
        print("commit")
    }
}

struct TrendView: View {
    var body: some View {
        Text("Trends")
    }
}

struct ChartView: View {
    var body: some View {
        Text("Charts")
    }
}
