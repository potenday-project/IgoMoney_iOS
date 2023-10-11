//
//  TextView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

public struct TextView: UIViewRepresentable {
  let configuration: Configuration
  @Binding var text: String
  @Binding var height: CGFloat
  
  public struct Configuration {
    var maxHeight: CGFloat
    var textFont: UIFont
    var textColor: UIColor = .label
    var textLimit: Int = 10
    var cornerRadius: CGFloat? = nil
    var borderWidth: CGFloat? = nil
    var borderColor: UIColor? = nil
    var isEditable: Bool = true
    var lineFragmentPadding: CGFloat = .zero
    var textContainerInset: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
    var placeholder: String? = nil
    var placeholderColor: UIColor = UIColor(named: "gray3") ?? .gray
  }
  
  public func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()
    
    if let cornerRadius = configuration.cornerRadius {
      textView.layer.cornerRadius = cornerRadius
      textView.layer.masksToBounds = true
    }
    
    if let borderWidth = configuration.borderWidth {
      textView.layer.borderWidth = borderWidth
    }
    
    if let borderColor = configuration.borderColor {
      textView.layer.borderColor = borderColor.cgColor
    }
    
    if let placeholder = configuration.placeholder {
      textView.text = placeholder
      textView.textColor = configuration.placeholderColor
    } else {
      textView.textColor = configuration.textColor
    }
    
    textView.font = configuration.textFont
    textView.isScrollEnabled = false
    textView.textContainer.lineFragmentPadding = configuration.lineFragmentPadding
    textView.textContainerInset = configuration.textContainerInset
    textView.delegate = context.coordinator
    
    return textView
  }
  
  public func updateUIView(_ uiView: UITextView, context: Context) {
    updateHeight(uiView)
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
  
  private func updateHeight(_ view: UITextView) {
    let size = view.sizeThatFits(CGSize(width: view.frame.width, height: .infinity))
    
    DispatchQueue.main.async {
      if size.height <= configuration.maxHeight {
        height = size.height
      }
    }
  }
  
  public class Coordinator: NSObject, UITextViewDelegate {
    var parent: TextView
    
    init(parent: TextView) {
      self.parent = parent
    }
    
    public func textViewDidChange(_ textView: UITextView) {
      parent.text = textView.text
      
      if textView.text.isEmpty {
        textView.textColor = parent.configuration.placeholderColor
      } else {
        textView.textColor = parent.configuration.textColor
      }
      
      if textView.text.count > parent.configuration.textLimit {
        textView.text.removeLast()
      }
      
      parent.updateHeight(textView)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.text == parent.configuration.placeholder {
        textView.text = ""
      }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
      if textView.text.isEmpty {
        textView.text = parent.configuration.placeholder
      }
    }
    
  }
}
