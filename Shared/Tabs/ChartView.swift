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
                        EmailHelper.shared.sendEmail(subject: "Expensify Category Breakdown Data for ()", body: "", to: []) // TODO
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
                    data: [1, 1, 1], // TODO (need category name to be displayed on top as well)
                    title: "Cat. Breakdown \(displayDate(date: startDate)) - \(displayDate(date: endDate))",
                    style: Styles.pieChartStyleOne, // TODO (each slice should be a different color, in order, probably tint)
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
}
