//
//  IGOTextFieldView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

public struct IGOTextField: UIViewRepresentable {
  @Binding var height: CGFloat
  @Binding var text: String
  let configuration: Configuration
  
  public struct Configuration {
    var contentLimit: Int = 15
    var maxHeight: CGFloat
    var textFont: UIFont
    var textColor: UIColor = .label
    var cornerRadius: CGFloat? = nil
    var borderWidth: CGFloat? = nil
    var borderColor: UIColor? = nil
    var isScrollable: Bool = true
    var isEditable: Bool = true
    var lineFragmentPadding: CGFloat = .zero
    var textContainerInset: UIEdgeInsets = .zero
    var placeholder: String? = nil
    var placeholderColor: UIColor = UIColor(named: "gray3") ?? .gray
  }
  
  public func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()
    
    textView.returnKeyType = .done
    
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
    textView.isScrollEnabled = configuration.isScrollable
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
    var parent: IGOTextField
    
    init(parent: IGOTextField) {
      self.parent = parent
    }
    
    public func textViewDidChange(_ textView: UITextView) {
      if textView.text.isEmpty {
        textView.textColor = parent.configuration.placeholderColor
      } else {
        textView.textColor = parent.configuration.textColor
      }
      
      if textView.text.count > parent.configuration.contentLimit || textView.text.last == "\n" {
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

extension IGOTextField.Configuration {
  static let inputTitle: Self = IGOTextField.Configuration(
    contentLimit: 15,
    maxHeight: 48,
    textFont: .pretendard(size: 16, weight: .medium),
    textColor: .label,
    cornerRadius: 4,
    borderWidth: 1,
    borderColor: ColorConstants.gray4.uiColor,
    isScrollable: false,
    isEditable: true,
    lineFragmentPadding: .zero,
    textContainerInset: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16),
    placeholder: "제목을 입력해주세요.", placeholderColor: ColorConstants.gray4.uiColor
  )
  
  static let inputContent : Self = IGOTextField.Configuration(
    contentLimit : 50,
    maxHeight : 200,
    textFont : .pretendard(size : 16, weight : .medium),
    textColor : .label,
    cornerRadius : 4,
    borderWidth : 1,
    borderColor : ColorConstants.gray4.uiColor,
    isEditable : true,
    lineFragmentPadding : .zero,
    textContainerInset : UIEdgeInsets(top : 12, left : 16, bottom : 12, right : 16),
    placeholder : "내용을 입력해주세요.",
    placeholderColor : ColorConstants.gray4.uiColor
  )
}
