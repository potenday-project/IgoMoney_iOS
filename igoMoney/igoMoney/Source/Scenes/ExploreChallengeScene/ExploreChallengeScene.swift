//
//  ExploreChallengeScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ExploreChallengeScene: View {
  let store: StoreOf<ExploreChallengeCore>
  
  private let challenges = Array(repeating: Challenge.default, count: 50)
  
  private enum FilterSectionItem: Int, CaseIterable {
    case all
    case challenge
    case money
    
    var description: String {
      switch self {
      case .all:
        return "전체"
      case .challenge:
        return "챌린지 주제"
      case .money:
        return "금액"
      }
    }
    
    var isMenu: Bool {
      return (self == .all) == false
    }
  }
  
  @ViewBuilder
  private func FilterButton(
    with viewStore: ViewStoreOf<ExploreChallengeCore>,
    isSelected: Bool,
    filterType: FilterSectionItem
  ) -> some View {
    Button {
      switch filterType {
      case .all:
        viewStore.send(.removeFilter)
      case .challenge, .money:
        viewStore.send(.openFilter(true))
      }
    } label: {
      HStack {
        switch filterType {
        case .challenge:
          if let category = viewStore.categorySelection {
            Text(category.description)
          } else {
            Text(filterType.description)
          }
        case .money:
          if let targetMoney = viewStore.moneySelection {
            Text(targetMoney.description)
          } else {
            Text(filterType.description)
          }
          
        default:
          Text(filterType.description)
        }
        
        
        if filterType.isMenu {
          Image(systemName: "chevron.down")
        }
      }
    }
    .buttonStyle(.plain)
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
    .foregroundColor(isSelected ? .black : ColorConstants.gray2)
    .background(
      RoundedRectangle(cornerRadius: 4)
        .stroke(
          isSelected ? ColorConstants.primary : ColorConstants.gray5
        )
    )
  }
  
  var body: some View {
    ZStack {
      VStack(spacing: 24) {
        IGONavigationBar {
          Text("챌린지 둘러보기")
        } leftView: {
          Button {
            
          } label: {
            Image(systemName: "chevron.left")
          }
        } rightView: {
          Button {
            
          } label: {
            Image(systemName: "plus.circle")
          }
        }
        .font(.pretendard(size: 20, weight: .bold))
        .padding(.vertical, 16)
        .accentColor(.black)
        .padding(.horizontal, 24)
        
        HStack(spacing: 8) {
          WithViewStore(store, observe: { $0 }) { viewStore in
            ForEach(FilterSectionItem.allCases, id: \.rawValue) { filter in
              FilterButton(
                with: viewStore,
                isSelected: filter == .all ? viewStore.isSelectAll : viewStore.isSelectAll == false,
                filterType: filter
              )
            }
          }
          
          Spacer()
        }
        .padding(.horizontal, 24)
        
        ScrollView(.vertical, showsIndicators: false) {
          VStack(spacing: 12) {
            ForEach(challenges, id: \.id) { challenge in
//              ExploreChallengeCellView(challenge: challenge)
//              .padding(.horizontal, 24)
            }
          }
          .padding(4)
        }
      }
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        if viewStore.showFilter {
          GeometryReader { proxy in
            IGOBottomSheetView(
              isOpen: viewStore.binding(
                get: \.showFilter,
                send: ExploreChallengeCore.Action.openFilter
              ),
              maxHeight: proxy.size.height * 0.65
            ) {
//              ExploreChallengeFilterView(viewStore: viewStore)
            }
            .edgesIgnoringSafeArea(.all)
          }
        }
      }
    }
    .navigationBarHidden(true)
  }
}

struct ExploreChallengeScene_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ExploreChallengeScene(
        store: Store(
          initialState: ExploreChallengeCore.State(),
          reducer: { ExploreChallengeCore() }
        )
      )
    }
  }
}
