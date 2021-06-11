import SwiftUI

struct TrendView: View {
    @ObservedObject var expensifyData: ExpensifyData
    @State var interval: String = "Weekly"
    @State var categoryId: String = "__ALL__"

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
                    })
                }

                VStack {
                    H2Text(text: "Category")
                    CustomPicker(selectedItemId: $categoryId, itemIds: ["__ALL__"] + expensifyData.getCategoryIds(), displayer: categoryIdDisplayer)
                }
                
                PText(text: "Chart for \(categoryIdDisplayer(categoryId: categoryId)) (\(interval))")

                Spacer() // flushes VStack to the top
            }
        }
    }
    
    func categoryIdDisplayer(categoryId: String) -> String {
        if categoryId == "__ALL__" { return "All" }
        else { return expensifyData.getCategory(id: categoryId) }
    }
}
