//
//  ProfileSettingCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ProfileSettingCore: Reducer {
  struct State: Equatable {
    var profileImageState: URLImageCore.State
    var nickNameState: NickNameCheckDuplicateCore.State
    var buttonEnable: Bool = false
    
    var presentPhotoPicker: Bool = false
    var selectedImage: UIImage?
  }
  
  enum Action: Equatable {
    case complete
    case presentPhotoPicker(Bool)
    case selectImage(UIImage?)
    
    case _updateProfileImageState(Image)
    
    case _uploadProfileImage
    case _uploadNickName
    case _uploadProfileImageResponse(TaskResult<[String: String]>)
    case _uploadNickNameResponse(TaskResult<Bool>)
    
    // Child Action
    case nickNameDuplicateAction(NickNameCheckDuplicateCore.Action)
    case profileImageAction(URLImageCore.Action)
  }
  
  @Dependency(\.userClient) var userClient
  @Dependency(\.imageClient) var imageClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.nickNameState, action: /Action.nickNameDuplicateAction) {
      NickNameCheckDuplicateCore()
    }
    
    Reduce { state, action in
      switch action {
      case .complete:
        return .send(._uploadProfileImage)
        
      case .presentPhotoPicker(let isPresent):
        state.presentPhotoPicker = isPresent
        return .none
        
      case .selectImage(let image):
        guard let uiImage = image else {
          return .none
        }
        
        state.selectedImage = image
        let image = Image(uiImage: uiImage)
        return .send(._updateProfileImageState(image))
        
      case ._updateProfileImageState(let image):
        state.profileImageState.loadingStatus = .success(image)
        return .none
        
      case ._uploadProfileImage:
        guard let selectedImageData = state.selectedImage?.pngData() else {
          return .send(._uploadNickName)
        }
        return .run { send in
          await send(
            ._uploadProfileImageResponse(
              TaskResult {
                try await imageClient.updateImageData(selectedImageData)
              }
            )
          )
        }
        
      case ._uploadNickName:
        if state.nickNameState.nickName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          return .none
        }
        
        return .run { [state] send in
          await send(
            ._uploadNickNameResponse(
              TaskResult {
                try await userClient.updateUserInformation(state.nickNameState.nickName)
              }
            )
          )
        }
        
      case ._uploadProfileImageResponse(.success(let data)):
        print(data)
        return .none
        
      case ._uploadProfileImageResponse(.failure):
        return .none
        
      case ._uploadNickNameResponse(.success):
        print("Upload NickName Success")
        return .none
        
      case ._uploadNickNameResponse(.failure):
        print("Upload NickName failure")
        return .none        
        
      case .nickNameDuplicateAction(._checkNickNameResponse(.success)):
        state.buttonEnable = true
        return .none
        
      case .nickNameDuplicateAction:
        return .none
        
      case .profileImageAction:
        return .none
      }
    }
  }
}

enum ConfirmState: CustomStringConvertible {
  case disableConfirm
  case readyConfirm
  case duplicateNickName
  case completeConfirm
  
  var description: String {
    switch self {
    case .disableConfirm:
      return TextConstants.baseHelpText
    case .readyConfirm:
      return TextConstants.confirmHelpText
    case .duplicateNickName:
      return TextConstants.duplicateNickName
    case .completeConfirm:
      return ""
    }
  }
}

private extension ConfirmState {
  enum TextConstants {
    static let baseHelpText = "최소 3자 이상의 영문, 한글 숫자만 입력해주세요."
    static let confirmHelpText = "중복확인 버튼을 눌러주세요."
    static let duplicateNickName = "중복된 닉네임입니다. 다른 닉네임을 사용해주세요."
  }
}
