//
//  ExploreChallengeScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ExploreChallengeScene: View {
  let store: StoreOf<ExploreChallengeCore>
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
      VStack(spacing: 16) {
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
                isSelected: filter == .all ? viewStore.isSelectAll == false : viewStore.isSelectAll,
                filterType: filter
              )
            }
          }
          
          Spacer()
        }
        .padding(.horizontal, 24)
        
        WithViewStore(store, observe: { $0 }) { viewStore in
          ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
              ForEach(viewStore.challenges, id: \.id) { challenge in
                ExploreChallengeCellView(challenge: challenge)
                  .onTapGesture {
                    viewStore.send(.selectChallenge(challenge))
                  }
              }
            }
            .padding(.top)
          }
          .background(
            NavigationLink(
              isActive: viewStore.binding(
                get: { $0.challengeSelection != nil },
                send: ExploreChallengeCore.Action.selectChallenge(nil)
              ),
              destination: {
                IfLetStore(
                  store.scope(
                    state: { $0.challengeSelection },
                    action: ExploreChallengeCore.Action.enterChallengeAction
                  )
                ) { store in
                  EnterChallengeScene(store: store)
                }
              }, label: {
                EmptyView()
              })
          )
        }
        .onAppear {
          store.send(.requestFetchChallenges)
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
