import SwiftUI

@main
struct ExpensifyApp: App {
    var body: some Scene {
        WindowGroup {
            MainView().onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
}

// adapted from https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
extension UIApplication: UIGestureRecognizerDelegate { }
extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}
