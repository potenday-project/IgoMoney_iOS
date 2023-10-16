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
        Text(filterType.description)
        
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
              ExploreChallengeCellView(challenge: challenge)
              .padding(.horizontal, 24)
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
              ExploreChallengeFilterView(viewStore: viewStore)
            }
            .edgesIgnoringSafeArea(.all)
          }
        }
      }
    }
  }
}

struct ExploreChallengeCellView: View {
  let challenge: Challenge
  var body: some View {
    HStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 2) {
        // TODO: - Challenge User Information 가져오기
        Text("머니레터님")
          .font(.pretendard(size: 12, weight: .medium))
          .foregroundColor(ColorConstants.gray3)
        
        Text(challenge.title)
          .lineLimit(1)
          .font(.pretendard(size: 16, weight: .bold))
        
        HStack {
          Text(challenge.targetAmount.description)
            .padding(.horizontal, 4)
            .background(ColorConstants.yellow)
            .cornerRadius(4)
          
          Text("#" + (challenge.category?.description ?? ""))
            .padding(.horizontal, 4)
            .background(ColorConstants.red)
            .cornerRadius(4)
          
          Text(challenge.startDate?.toString(with: "⏰ MM월dd일 시작") ?? "")
            .padding(.horizontal, 4)
            .background(ColorConstants.primary7)
            .cornerRadius(4)
        }
        .font(.pretendard(size: 12, weight: .medium))
      }
      
      Image("default_profile")
    }
    .padding(16)
    .background(Color.white)
    .cornerRadius(10)
    .shadow(color: ColorConstants.gray2.opacity(0.2), radius: 4, y: 2)
  }
}

struct ExploreChallengeFilterView: View {
  let viewStore: ViewStoreOf<ExploreChallengeCore>
  
  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text("챌린지 주제")
        .font(.pretendard(size: 18, weight: .bold))
      
      LazyVGrid(columns: Array(repeating: .init(), count: 3)) {
        ForEach(ChallengeCategory.allCases, id: \.rawValue) { category in
          Button {
            
          } label: {
            ChallengeCategoryView(
              isSelection: category.rawValue == 1,
              category: category
            )
          }
        }
      }
      
      Text("챌린지 금액")
        .font(.pretendard(size: 18, weight: .bold))
      
      HStack {
        ForEach(TargetMoneyAmount.allCases, id: \.money) { amount in
          ChallengeTargetMoneyView(
            isSelection: amount.money == 10000,
            amount: amount
          )
        }
      }
      
      Spacer()
      
      Button("완료") {
        viewStore.send(.confirmFilter)
      }
      .font(.pretendard(size: 18, weight: .medium))
      .frame(maxWidth: .infinity)
      .buttonStyle(.plain)
      .padding()
      .background(ColorConstants.primary)
      .cornerRadius(8)
      .padding(.bottom, 32)
    }
    .padding(.horizontal, 24)
  }
}

struct ExploreChallengeScene_Previews: PreviewProvider {
  static var previews: some View {
    ExploreChallengeScene(
      store: Store(
        initialState: ExploreChallengeCore.State(),
        reducer: { ExploreChallengeCore() }
      )
    )
  }
}
