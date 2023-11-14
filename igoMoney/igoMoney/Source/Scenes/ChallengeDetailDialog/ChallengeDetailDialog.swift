//
//  ChallengeDetailDialog.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import ComposableArchitecture

struct ChallengeDetailDialog: View {
  @State var selectedIndex: Int = .zero
  let store: StoreOf<ChallengeRecordDetailCore>
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      /// Header Control Section
      HStack(spacing: .zero) {
        Button {
          
        } label: {
          Image("icon_xmark")
        }
        
        Spacer()
        
        Button {
          
        } label: {
          Image("icon_pancil")
        }
        .padding(.trailing, 8)
        
        Menu {
          Button {
            
          } label: {
            HStack {
              Text("삭제하기")
              
              Spacer()
              
              Image(systemName: "trash")
            }
            .foregroundColor(.red)
          }
        } label: {
          Image("icon_dot3")
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
        }
      }
      .padding(.bottom, 24)
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        Text(viewStore.record.date.toString(with: "MM월 dd일"))
          .font(.pretendard(size: 16, weight: .bold))
        
        Divider()
        
        Text(viewStore.cost.description + "원 지출")
          .font(.pretendard(size: 16, weight: .medium))
      }
      
      Divider()
      
      TabView(selection: $selectedIndex) {
        ForEach(0..<5) { index in
          Image("example_food")
            .resizable()
            .scaledToFill()
            .clipped(antialiased: true)
            .tag(index)
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .indexViewStyle(.page(backgroundDisplayMode: .never))
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .overlay(
        HStack(spacing: .zero) {
          Text("\(selectedIndex)")
            .foregroundColor(ColorConstants.gray4)
          
          Text(" / \(5)")
            .foregroundColor(ColorConstants.gray2)
        }.font(.pretendard(size: 11, weight: .medium))
          .padding(.horizontal, 8)
          .padding(.vertical, 2)
          .background(ColorConstants.gray3)
          .cornerRadius(.infinity)
          .padding(12),
        alignment: .bottomTrailing
      )
      
      Divider()
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        Text(viewStore.title)
          .font(.pretendard(size: 16, weight: .bold))
      }
      
      Divider()
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        Text(viewStore.content)
          .font(.pretendard(size: 14, weight: .bold))
      }
    }
    .padding(24)
    .background(Color.white)
    .cornerRadius(8)
    .padding()
  }
}

#Preview {
  ZStack {
    Color.gray
    
    ChallengeDetailDialog(
      store: Store(
        initialState: ChallengeRecordDetailCore.State(record: .default),
        reducer: { ChallengeRecordDetailCore() }
      )
    )
    .frame(height: UIScreen.main.bounds.height * 0.7)
  }
}
