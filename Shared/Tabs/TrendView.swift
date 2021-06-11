import SwiftUI

struct TrendView: View {
    @ObservedObject var expensifyData: ExpensifyData
    @State var interval: String = "Weekly"
    @State var categoryId: String = "__ALL__"
    @State var barChartView: BarChartView? = BarChartView(
        data: ChartData(values: [("", 0.0)]),
        title: "",
        form: CGSize(width: 360, height: 400),
        cornerImage: nil
    )
        
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                HStack {
                    H1Text(text: "Temporal Trends")
                    Button(action: {
                        EmailHelper.shared.sendEmail(subject: "Expensify Trend Data for \(categoryIdDisplayer(categoryId: categoryId)) (\(interval))", body: expensifyData.getTrendDataExport(interval: interval, categoryId: categoryId), to: [])
                    }) { SystemImage(name: "square.and.arrow.down", size: 25) }
                }

                VStack {
                    H2Text(text: "Aggregation Interval")
                    CustomPicker(selectedItemId: $interval, itemIds: ["Daily", "Weekly", "Biweekly", "Monthly", "Yearly"], displayer: { itemId in
                        return itemId
                    }, selectedCallback: { _ in refreshBarChartView2(); sleep(1); refreshBarChartView() })
                }

                VStack {
                    H2Text(text: "Category")
                    CustomPicker(selectedItemId: $categoryId, itemIds: ["__ALL__"] + expensifyData.getCategoryIds(), displayer: categoryIdDisplayer, selectedCallback: { _ in refreshBarChartView2(); sleep(1); refreshBarChartView() })
                }

                if barChartView != nil { barChartView! }

                Spacer() // flushes VStack to the top
            }
        }.onAppear(perform: refreshBarChartView)
    }
    
    func categoryIdDisplayer(categoryId: String) -> String {
        if categoryId == "__ALL__" { return "All" }
        else { return expensifyData.getCategory(id: categoryId) }
    }

    func refreshBarChartView() -> Void {
        print("refreshing with \(interval) \(categoryIdDisplayer(categoryId: categoryId)), currently barChartView is \(String(describing: barChartView))")
        barChartView = BarChartView(
            data: ChartData(values: expensifyData.getTrendData(interval: interval, categoryId: categoryId)),
            title: "Trend for \(categoryIdDisplayer(categoryId: categoryId)) (\(interval))",
            style: Styles.barChartMidnightGreenLight,
            form: CGSize(width: 360, height: 400),
            cornerImage: nil,
            valueSpecifier: "$%.2f (USD)"
        )
    }

    func refreshBarChartView2() -> Void {
        print("clearing")
        barChartView = nil
    }
}
