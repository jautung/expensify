import SwiftUI

struct ChartView: View {
    @ObservedObject var expensifyData: ExpensifyData

    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                H1Text(text: "Category Breakdown")
                Spacer() // flushes VStack to the top
            }
        }
    }
}
