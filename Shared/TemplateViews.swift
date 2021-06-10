import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Color("BackgroundColor").ignoresSafeArea()
    }
}

struct H1Text: View {
    var text: String
    var body: some View {
        Text(text)
            .padding(5)
            .font(.system(size: 36, weight: .bold))
            .foregroundColor(Color("TextColor"))
    }
}

struct H2Text: View {
    var text: String
    var body: some View {
        Text(text)
            .padding(5)
            .font(.system(size: 24, weight: .regular))
            .foregroundColor(Color("TextColor"))
    }
}

struct SystemImage: View {
    var name: String
    var body: some View {
        Image(systemName: name)
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .padding(5)
            .foregroundColor(Color("SystemImageColor"))
    }
}
