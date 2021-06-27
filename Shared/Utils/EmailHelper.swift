// adapted from https://dev.to/tranthanhvu/how-to-send-emails-in-swiftui-1ail

import SwiftUI
import MessageUI

class EmailHelper: NSObject, MFMailComposeViewControllerDelegate {
    static let shared = EmailHelper()

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    func sendEmail(subject: String, body: String, to: [String]) {
        guard let viewController = UIApplication.shared.windows.first?.rootViewController else { return }

        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let tos = to.joined(separator: ",")

        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        var haveSomeMailbox: Bool = false

        if MFMailComposeViewController.canSendMail() { // default mail
            haveSomeMailbox = true
            alert.addAction(UIAlertAction(title: "Default Mail", style: .default, handler: { action in
                let mailCompose = MFMailComposeViewController()
                mailCompose.setSubject(subject)
                mailCompose.setMessageBody(body, isHTML: false)
                mailCompose.setToRecipients(to)
                mailCompose.mailComposeDelegate = self
                viewController.present(mailCompose, animated: true, completion: nil)
            }))
        }

        if let defaultUrl = URL(string: "mailto:\(tos)?subject=\(subjectEncoded)&body=\(bodyEncoded)"), UIApplication.shared.canOpenURL(defaultUrl) { // mail app
            haveSomeMailbox = true
            alert.addAction(UIAlertAction(title: "Mail App", style: .default, handler: { action in
                UIApplication.shared.open(defaultUrl)
            }))
        }

        if let gmailUrl = URL(string: "googlegmail://co?to=\(tos)&subject=\(subjectEncoded)&body=\(bodyEncoded)"), UIApplication.shared.canOpenURL(gmailUrl) { // gmail app
            haveSomeMailbox = true
            alert.addAction(UIAlertAction(title: "Gmail App", style: .default, handler: { action in
                UIApplication.shared.open(gmailUrl)
            }))
        }
            
        if haveSomeMailbox {
            alert.title = "Choose mailbox to use"
        } else {
            alert.title = "Please add some mailbox to Settings"
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) {
                alert.addAction(UIAlertAction(title: "Open Settings App", style: .default, handler: { action in
                    UIApplication.shared.open(settingsUrl)
                }))
            }
        }
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
