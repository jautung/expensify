import SwiftUI

struct ChartView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            Text("Chart")
        }
    }
}

// DEBUGGING PREVIEW BELOW THIS LINE

struct ChartViewPreview: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
