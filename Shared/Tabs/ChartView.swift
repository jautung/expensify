import SwiftUI

struct ChartView: View {
    @ObservedObject var expensifyData: ExpensifyData
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()

    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                HStack {
                    H1Text(text: "Cat. Breakdown")
                    Button(action: {
                        EmailHelper.shared.sendEmail(subject: "Expensify Category Breakdown Data for \(displayDate(date: startDate)) - \(displayDate(date: endDate))", body: expensifyData.getBreakdownDataExport(startDate: startDate, endDate: endDate), to: [])
                    }) { SystemImage(name: "square.and.arrow.down", size: 25) }
                }

                VStack {
                    H2Text(text: "Start Date")
                    DatePicker(selection: $startDate, displayedComponents: [.date], label: { EmptyView() }).labelsHidden()
                }

                VStack {
                    H2Text(text: "End Date")
                    DatePicker(selection: $endDate, displayedComponents: [.date], label: { EmptyView() }).labelsHidden()
                }

                Spacer() // flushes chart to the bottom

                PieChartView(
                    data: ChartData(values: postProcBreakdownData(breakdownData: expensifyData.getBreakdownData(startDate: startDate, endDate: endDate))),
                    title: "Cat. Breakdown \(displayDate(date: startDate)) - \(displayDate(date: endDate))",
                    style: Styles.pieChartMidnightGreenLight,
                    form: CGSize(width: 360, height: 400),
                    cornerImage: nil,
                    valueSpecifier: "$%.2f (USD)"
                ).padding(30)
            }
        }.onAppear() {
            var dateMidnightComponents = DateComponents()
            dateMidnightComponents.hour = 0
            dateMidnightComponents.minute = 0
            dateMidnightComponents.second = 0
            dateMidnightComponents.nanosecond = 0
            startDate = Calendar.current.nextDate(after: expensifyData.getExpenseFirstDate(), matching: dateMidnightComponents, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward)!
            endDate = Calendar.current.nextDate(after: expensifyData.getExpenseLastDate(), matching: dateMidnightComponents, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)!
        }
    }
    
    func displayDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd/yyyy"
        return formatter.string(from: date)
    }
    
    func postProcBreakdownData(breakdownData: Array<(categoryId: String, amount: Float)>) -> Array<(category: String, amount: Float)> {
        var readableBreakdownData: Array<(category: String, amount: Float)> = []
        for categoryIndex in 0..<breakdownData.count {
            readableBreakdownData.append((category: maybeTruncate(s: expensifyData.getCategory(id: breakdownData[categoryIndex].categoryId)), amount: breakdownData[categoryIndex].amount))
        }
        return readableBreakdownData
    }
    
    func maybeTruncate(s: String) -> String {
        if (s.count <= 20) { return s }
        else { return s[..<s.index(s.startIndex, offsetBy: 20)] + "..." }
    }
}
