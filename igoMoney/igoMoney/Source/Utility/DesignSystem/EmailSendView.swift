//
//  EmailSendView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import MessageUI
import SwiftUI

struct EmailSendView: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> MFMailComposeViewController {    
    let mail = MFMailComposeViewController()
    let contents = """
    아이고머니 서비스를 이용해주셔서 감사합니다.
    불편한 사항이나 버그 제보를 받고 있습니다.
    아래 부분에 작성해주시면 빠른 시일 내에 개선하도록 하겠습니다.
    <hr>
    """
    mail.setSubject("[아이고머니] 서비스 문의하기")
    mail.setToRecipients(["dlrudals8899@gmail.com"])
    mail.setMessageBody(contents, isHTML: true)
    mail.mailComposeDelegate = context.coordinator
    return mail
  }
  
  func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) { }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
  
  class Coordinator: NSObject, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    var parent: EmailSendView
    
    init(parent: EmailSendView) {
      self.parent = parent
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
      controller.dismiss(animated: true)
    }
  }
}
