//
//  IGOTextFieldView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import UIKit

import ComposableArchitecture

// Configuration
public struct TextFieldConfiguration {
  var isEditable: Bool = true
  var maxHeight: CGFloat = 300
  var textFont: UIFont = .pretendard(size: 16, weight: .regular)
  var textColor: UIColor = .label
  var placeholder: String? = nil
  var placeholderColor: UIColor = UIColor(named: "gray3") ?? .gray
}

class IGOTextFieldView: UITextView, UITextViewDelegate {
  private var viewStore: ViewStoreOf<TextFieldCore>?
  private var configuration: TextFieldConfiguration = TextFieldConfiguration()
  private var cancellables: Set<AnyCancellable> = []
  
  /// Initializer
  init(with viewStore: ViewStoreOf<TextFieldCore>, configuration: TextFieldConfiguration) {
    super.init(frame: .zero, textContainer: nil)
    self.viewStore = viewStore
    self.configuration = configuration
    
    configureAttributes()
    delegate = self
    binding()
    
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  /// Binding Method
  func binding() {
    viewStore?.publisher
      .map(\.text)
      .assign(to: \.text, on: self)
      .store(in: &cancellables)
  }
  
  /// Delegate Method
  public func textViewDidChange(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.textColor = configuration.placeholderColor
    } else {
      textView.textColor = configuration.textColor
    }
    
    if textView.text.count > viewStore?.textLimit ?? .zero {
      textView.text.removeLast()
      return
    }
    
    viewStore?.send(.textDidChange(textView.text))
  }
  
  public func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == configuration.placeholder {
      viewStore?.send(.textDidChange(""))
    }
  }
  
  public func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      guard let placeholder = configuration.placeholder else { return }
      viewStore?.send(.textDidChange(placeholder))
    }
  }
}

extension IGOTextFieldView {
  func configureAttributes() {
    translatesAutoresizingMaskIntoConstraints = false
    
    if let placeholder = configuration.placeholder {
      viewStore?.send(.textDidChange(placeholder))
      textColor = configuration.placeholderColor
    } else {
      textColor = configuration.textColor
    }
    
    font = configuration.textFont
    isScrollEnabled = false
  }
}
