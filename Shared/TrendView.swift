import SwiftUI

struct TrendView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                H1Text(text: "Temporal Trends")
                Spacer() // flushes VStack to the top
            }
        }
    }
}
