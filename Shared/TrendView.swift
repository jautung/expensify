import SwiftUI

struct TrendView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            Text("Trends")
        }
    }
}

// DEBUGGING PREVIEW BELOW THIS LINE

struct TrendViewPreview: PreviewProvider {
    static var previews: some View {
        TrendView()
    }
}
