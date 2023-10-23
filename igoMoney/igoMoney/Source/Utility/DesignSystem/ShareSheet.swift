//
//  ShareSheet.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

extension View {
  func shareSheet(_ item: Binding<[URL]?>, onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil) -> some View {
    background(ShareSheet(item: item, completion: onComplete))
  }
}

private struct ShareSheet: UIViewControllerRepresentable {
  @Binding var item: [URL]?
  private var completion: UIActivityViewController.CompletionWithItemsHandler?
  
  init(item: Binding<[URL]?>, completion: UIActivityViewController.CompletionWithItemsHandler? = nil) {
    self._item = item
    self.completion = completion
  }
  
  func makeUIViewController(context: Context) -> ActivityViewController {
    return ActivityViewController(item: $item, completion: completion)
  }
  
  func updateUIViewController(_ controller: ActivityViewController, context: Context) {
    controller.item = $item
    controller.completion = completion
    controller.updateState()
  }
  
  fileprivate final class ActivityViewController: UIViewController {
    var item: Binding<[URL]?>
    var completion: UIActivityViewController.CompletionWithItemsHandler?
    
    init(item: Binding<[URL]?>, completion: UIActivityViewController.CompletionWithItemsHandler?) {
      self.item = item
      self.completion = completion
      super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
      fatalError()
    }
    
    override func didMove(toParent parent: UIViewController?) {
      super.didMove(toParent: parent)
      updateState()
    }
    
    fileprivate func updateState() {
      guard let item = item.wrappedValue else { return }
      
      if presentedViewController == nil {
        let controller = UIActivityViewController(
          activityItems: item,
          applicationActivities: nil
        )
        
        controller.completionWithItemsHandler = { [weak self] (activity, success, items, error) in
          self?.item.wrappedValue = nil
          self?.completion?(activity, success, items, error)
        }
        
        controller.popoverPresentationController?.permittedArrowDirections = .down
        controller.popoverPresentationController?.sourceView = view
        
        present(controller, animated: true)
      }
    }
  }
}


