//
//  IGOPhotoPicker.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import PhotosUI

struct IGOPhotoPicker: UIViewControllerRepresentable {
  @Binding var selectedImage: UIImage?
  let configuration: PHPickerConfiguration
  
  func makeUIViewController(context: Context) -> PHPickerViewController {
    let controller = PHPickerViewController(configuration: configuration)
    controller.delegate = context.coordinator
    return controller
  }
  
  func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(parent: self)
  }
  
  class Coordinator: PHPickerViewControllerDelegate {
    private let parent: IGOPhotoPicker
    
    init(parent: IGOPhotoPicker) {
      self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      picker.dismiss(animated: true)
      
      guard let imageAsset = results.first else { return }
      
      if imageAsset.itemProvider.canLoadObject(ofClass: UIImage.self) {
        imageAsset.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
          if error != nil {
            return
          }
          
          guard let image = image as? UIImage else { return }
          
          DispatchQueue.main.async {
            self?.parent.$selectedImage.wrappedValue = image.resize(to: 100)
          }
        }
      }
    }
  }
}
