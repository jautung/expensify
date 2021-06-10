import SwiftUI

struct ChartView: View {
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
