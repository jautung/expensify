// adapted from https://github.com/momin96/SwiftUI-with-UIAlertController

import SwiftUI

struct AlertControlView: UIViewControllerRepresentable {
    @Binding var showAlert: Bool
    var title: String
    var message: String
    var placeholder: String? // nil if a text field is not required
    var submitCallback: (String) -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertControlView>) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AlertControlView>) {
        guard context.coordinator.alert == nil else { return }
        
        if showAlert {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            context.coordinator.alert = alert
            
            if placeholder != nil {
                alert.addTextField { textField in
                    textField.placeholder = placeholder!
                    textField.delegate = context.coordinator
                }
            }
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "") , style: .destructive) { _ in
                alert.dismiss(animated: true) {
                    showAlert = false
                }
            })
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Submit", comment: ""), style: .default) { _ in
                if placeholder != nil { // alert with text field
                    if let textField = alert.textFields?.first, let text = textField.text {
                        submitCallback(text)
                    }
                } else { // alert without text field
                    submitCallback("")
                }
                alert.dismiss(animated: true) {
                    showAlert = false
                }
            })
            
            DispatchQueue.main.async {
                uiViewController.present(alert, animated: true, completion: {
                    showAlert = false
                    context.coordinator.alert = nil
                })
            }
        }
    }

    func makeCoordinator() -> AlertControlView.Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var alert: UIAlertController?
        var control: AlertControlView
        init(_ control: AlertControlView) {
            self.control = control
        }
    }
}
