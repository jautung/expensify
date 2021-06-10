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
            .padding(30)
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

struct H2TextError: View {
    var text: String
    var body: some View {
        Text(text)
            .padding(5)
            .font(.system(size: 24, weight: .regular))
            .foregroundColor(Color("TextErrorColor"))
    }
}

struct PText: View {
    var text: String
    var body: some View {
        Text(text)
            .padding(2)
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(Color("TextColor"))
    }
}

struct CustomButton: View {
    var text: String
    var callback: () -> Void
    var body: some View {
        Button(action: callback) {
            Text(text)
                .frame(width: 280, height: 60)
                .font(.system(size: 24, weight: .regular))
                .background(Color("ButtonColor"))
                .cornerRadius(10)
                .shadow(radius: 5)
        }.padding(20)
    }
}

struct CustomDivider: View {
    var size: CGFloat
    var body: some View {
        Divider().padding(size)
    }
}

struct SystemImage: View {
    var name: String
    var size: CGFloat
    var body: some View {
        Image(systemName: name)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .padding(size/6.0)
            .foregroundColor(Color("SystemImageColor"))
    }
}

struct CustomPicker: View {
    @Binding var selectedItemId: String
    var itemIds: Array<String>
    var displayer: (String) -> String // map from id to displayable name
    var body: some View {
        HStack {
            Picker(displayer(selectedItemId), selection: $selectedItemId) {
                ForEach(itemIds, id: \.self) {
                    Text(displayer($0)).foregroundColor(.black)
                }
            }.pickerStyle(MenuPickerStyle()).frame(height: 40)
            SystemImage(name: "arrowtriangle.down.fill", size: 10)
        }
    }
}

struct AlertControlView: UIViewControllerRepresentable { // adapted from https://github.com/momin96/SwiftUI-with-UIAlertController
    @Binding var showAlert: Bool
    var title: String
    var message: String
    var confirmation: String? // nil if no confirmation is required (i.e. only close)
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
            
            if confirmation != nil {
                alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "") , style: .destructive) { _ in
                    alert.dismiss(animated: true) {
                        showAlert = false
                    }
                })
            }
            
            alert.addAction(UIAlertAction(title: NSLocalizedString(confirmation == nil ? "Close" : confirmation!, comment: ""), style: .default) { _ in
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
