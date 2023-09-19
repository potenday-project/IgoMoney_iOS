//
//  HelpScrollCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct HelpScrollCore: Reducer {
    struct State: Equatable {
        let informations = HelpInformation.allCases
        
        var selectedHelp: HelpInformation = .first
    }
    
    enum Action: Equatable {
        case selectItem(HelpInformation)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .selectItem(let information):
                state.selectedHelp = information
                return .none
            }
        }
    }
}


enum HelpInformation: Int, CaseIterable {
    case first
    case second
    case third
    case fourth
    
    var title: String {
        switch self {
        case .first:
            return "일주일동안\n함께 절약하는 챌린지"
        case .second:
            return "선택할 수 있는\n챌린지"
        case .third:
            return "인증하면\n하루완료!"
        case .fourth:
            return "승리 포인트\n획득"
        }
    }
    
    var body: String {
        switch self {
        case .first:
            return "돈을 절약하고 싶은 사람들과 함께\n일주일 버티기 챌린지에 도전해보세요!"
        case .second:
            return "내가 도전할 수 있을만한 금액의\n챌린지 선택하세요"
        case .third:
            return "하루마다 내가 지출한\n금액과 사진을 인증하세요"
        case .fourth:
            return "더 적게 지출하면서 일주일을 버틴\n사람이 승리뱃지를 가져가요."
        }
    }
}
