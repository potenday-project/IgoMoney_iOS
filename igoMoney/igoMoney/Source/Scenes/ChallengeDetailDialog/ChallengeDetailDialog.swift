//
//  ChallengeDetailDialog.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import ComposableArchitecture

struct ChallengeDetailDialog: View {
  let store: StoreOf<ChallengeRecordDetailCore>
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      /// Header Control Section
      HStack(spacing: .zero) {
        Button {
          
        } label: {
          Image(systemName: "xmark")
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
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
          Image(systemName: "ellipsis")
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
        }
      }
      .padding(.vertical, 24)
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        Text(viewStore.record.date.toString(with: "MM월 dd일"))
        
        Divider()
        
        Text(viewStore.cost.description + "원 지출")
      }
      
      Divider()
      
      TabView {
        ForEach(0..<5) { index in
          Image("example_food")
            .resizable()
            .scaledToFill()
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .indexViewStyle(.page(backgroundDisplayMode: .never))
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .frame(maxHeight: .infinity)
      
      Divider()
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        Text(viewStore.title)
      }
      
      Divider()
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        Text(viewStore.content)
      }
    }
    .padding(.horizontal, 24)
  }
}

#Preview {
  ChallengeDetailDialog(
    store: .init(
      initialState: ChallengeRecordDetailCore.State(
        record: .default
      ),
      reducer: { ChallengeRecordDetailCore() }
    )
  )
}
