//
//  ChallengeStateScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct ChallengeStateScene: View {
  @State private var showWrite: Bool = false
  @State private var showDetailList: Bool = true
  @State private var showDetail: Bool = false
  
  var body: some View {
    
    VStack {
      IGONavigationBar {
        EmptyView()
      } leftView: {
        Text("참여중인 챌린지")
          .font(.pretendard(size: 20, weight: .bold))
          .foregroundColor(.white)
      } rightView: {
        Button(action: { }) {
          Text("대결 포기하기")
        }
        .font(.pretendard(size: 12, weight: .medium))
        .foregroundColor(ColorConstants.gray4)
      }
      .padding(.horizontal, 24)
      .padding(.vertical, 16)
      
      ScrollView(showsIndicators: false) {
        VStack {
          VStack(alignment: .leading, spacing: 2) {
            HStack {
              Text("뒷주머니님과 대결중")
                .font(.pretendard(size: 14, weight: .bold))
                .foregroundColor(ColorConstants.gray2)
              
              Spacer()
              
              Text("💸 30000원")
                .font(.pretendard(size: 12, weight: .medium))
                .padding(.horizontal, 4)
                .background(ColorConstants.blue)
                .cornerRadius(4)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            HStack {
              Text("일주일에 3만원으로 살아남기")
                .font(.pretendard(size: 16, weight: .bold))
              
              Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
          }
          .background(Color.white)
          .cornerRadius(10)
          .padding(.horizontal, 24)
          .padding(.top, 8)
          
          VStack(spacing: 8) {
            VStack {
              HStack(alignment: .bottom) {
                Text("아이고 머니님")
                  .font(.pretendard(size: 16, weight: .bold))
                
                Spacer()
                
                Text("30000원")
                  .font(.pretendard(size: 12, weight: .medium))
                  .foregroundColor(ColorConstants.gray2)
              }
              .padding(.top, 16)
              
              ZStack {
                RoundedRectangle(cornerRadius: .infinity)
                  .fill(ColorConstants.primary6)
                  .frame(maxWidth: .infinity, maxHeight: 8)
                  .overlay(
                    RoundedRectangle(cornerRadius: .infinity)
                      .fill(ColorConstants.primary2)
                      .frame(maxWidth: 100, maxHeight: 8),
                    alignment: .leading
                  )
              }
              
              HStack {
                Text("누적 금액")
                  .font(.pretendard(size: 12, weight: .medium))
                  .foregroundColor(ColorConstants.gray)
                
                Spacer()
                
                Text("3000원")
                  .foregroundColor(ColorConstants.primary2)
                  .font(.pretendard(size: 12, weight: .bold))
              }
            }
            
            Divider()
              .background(ColorConstants.gray4)
            
            VStack {
              HStack(alignment: .center) {
                Text("뒷주머니님")
                  .font(.pretendard(size: 16, weight: .bold))
                
                Spacer()
                
                Text("30000원")
                  .font(.pretendard(size: 12, weight: .medium))
                  .foregroundColor(ColorConstants.gray2)
              }
              
              ZStack {
                RoundedRectangle(cornerRadius: .infinity)
                  .fill(ColorConstants.primary6)
                  .frame(maxWidth: .infinity, maxHeight: 8)
                  .overlay(
                    RoundedRectangle(cornerRadius: .infinity)
                      .fill(ColorConstants.primary2)
                      .frame(maxWidth: 100, maxHeight: 8),
                    alignment: .leading
                  )
              }
              
              HStack {
                Text("누적 금액")
                  .font(.pretendard(size: 12, weight: .medium))
                  .foregroundColor(ColorConstants.gray)
                
                Spacer()
                
                Text("3000원")
                  .foregroundColor(ColorConstants.primary2)
                  .font(.pretendard(size: 12, weight: .bold))
              }
            }
            
            Divider()
              .background(ColorConstants.gray4)
            
            Text("현재 오마이머니님이 더 절약하고 있어요 🤔")
              .font(.pretendard(size: 14, weight: .bold))
              .padding(.bottom, 16)
          }
          .padding(.horizontal, 16)
          .background(ColorConstants.primary8)
          .cornerRadius(10)
          .padding(.horizontal, 24)
          .padding(.top, 16)
          .padding(.bottom, 36)
          
          VStack(spacing: .zero) {
            HStack {
              Button(action: { }) {
                Text("나의 챌린지")
              }
              .padding(.bottom, 8)
              .frame(maxWidth: .infinity)
              .overlay(
                Rectangle()
                  .frame(height: 1),
                alignment: .bottom
              )
              .accentColor(.black)
              
              Button(action: { }) {
                Text("상대방 챌린지")
              }
              .padding(.bottom, 8)
              .frame(maxWidth: .infinity)
              .overlay(
                Rectangle()
                  .frame(height: 1),
                alignment: .bottom
              )
              .foregroundColor(ColorConstants.gray3)
            }
            .font(.pretendard(size: 16, weight: .medium))
            .padding(.top, 12)
            .padding(.bottom, 24)
            .font(.pretendard(size: 16, weight: .bold))
            
            
            VStack(spacing: 12) {
              HStack {
                Text("🔥 9월 24일 일요일 1일차")
                
                Spacer()
              }
              .font(.pretendard(size: 18, weight: .bold))
              
              HStack(spacing: .zero) {
                ForEach(0..<7) { index in
                  VStack(spacing: 8) {
                    Text("9/24")
                      .font(.pretendard(size: 12, weight: .medium))
                      .frame(maxWidth: .infinity)
                    
                    Text("\(index + 1)일차")
                      .font(.pretendard(size: 14, weight: .semiBold))
                      .lineHeight(font: .pretendard(size: 14, weight: .semiBold), lineHeight: 21)
                      .frame(maxWidth: .infinity)
                    
                    Image(systemName: "checkmark.circle")
                      .frame(width: 20, height: 20)
                      .frame(maxWidth: .infinity)
                  }
                  .padding(.vertical, 8)
                  .foregroundColor(
                    index == .zero ? Color.black : ColorConstants.gray3
                  )
                  .background(
                    index == .zero ? ColorConstants.primary7 : .clear
                  )
                  .cornerRadius(8)
                }
              }
              .padding(.vertical, 12)
              .padding(.horizontal, 16)
              .background(Color.white)
              .cornerRadius(8)
              .shadow(color: ColorConstants.gray2.opacity(0.1), radius: 4, y: 2)
            }
            .padding(.bottom, 16)
            
            HStack(alignment: .center) {
              VStack(alignment: .leading) {
                Text("9월 24일 1일차")
                  .font(.pretendard(size: 12, weight: .medium))
                  .foregroundColor(ColorConstants.gray)
                  .lineHeight(font: .pretendard(size: 12, weight: .medium), lineHeight: 16)
                
                Text("오늘 하루 지출 내역 입력하기")
                  .font(.pretendard(size: 16, weight: .bold))
                  .lineHeight(font: .pretendard(size: 16, weight: .bold), lineHeight: 23)
                  .foregroundColor(.black)
              }
              
              Spacer()
              
              Image("icon_edit")
            }
            .padding(16)
            .background(ColorConstants.primary8)
            .cornerRadius(10)
            .shadow(color: ColorConstants.gray2.opacity(0.1), radius: 4, y: 2)
            .onTapGesture {
              showWrite.toggle()
            }
            
            if showDetailList {
              VStack(spacing: .zero) {
                HStack(spacing: 12) {
                  Image("example_food")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60, alignment: .center)
                    .cornerRadius(9)
                  
                  VStack(alignment: .leading, spacing: 4) {
                    Text("9월 24일 1일차")
                      .font(.pretendard(size: 12, weight: .medium))
                    
                    Text("오늘은 도시락을 먹어서 지출은 커피값만!")
                      .lineLimit(1)
                      .font(.pretendard(size: 16, weight: .bold))
                    
                    Text("총 3000원 지출")
                      .padding(.horizontal, 4)
                      .background(ColorConstants.blue)
                      .font(.pretendard(size: 12, weight: .medium))
                  }
                  
                  Spacer()
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: ColorConstants.gray2.opacity(0.1), radius: 4, y: 2)
                .onTapGesture {
                  showDetail = true
                }
              }
              .padding(.top, 12)
            }
          }
          .padding(.horizontal, 24)
          .padding(.bottom, 300)
          .background(Color.white.edgesIgnoringSafeArea(.all))
          .cornerRadius(10, corner: .topLeft)
          .cornerRadius(10, corner: .topRight)
        }
      }
    }
    .navigationBarHidden(true)
    .background(
      Color("background_color")
        .edgesIgnoringSafeArea(.all)
    )
    .fullScreenCover(isPresented: $showWrite) {
      WriteChallengeView(showWrite: $showWrite, showDetailList: $showDetailList)
    }
    .fullScreenCover(isPresented: $showDetail) {
      ChallengeDetailView(showDetail: $showDetail)
    }
  }
}

struct WriteChallengeView: View {
  @Binding var showWrite: Bool
  @Binding var showDetailList: Bool
  @State private var imageList: [String] = []
  @State private var moneyAmount: String = ""
  @State private var title: String = ""
  @State private var content: String = ""
  @State private var showAlert: Bool = false
  
  var body: some View {
    VStack(spacing: .zero) {
      IGONavigationBar {
        Text("9월 24일 1일차")
          .font(.pretendard(size: 20, weight: .bold))
      } leftView: {
        Image(systemName: "xmark")
          .onTapGesture {
            showWrite.toggle()
          }
      } rightView: {
        EmptyView()
      }
      .padding(.vertical, 16)
      .padding(.horizontal, 24)
      
      ScrollView {
        VStack(spacing: 16) {
          VStack {
            HStack {
              Text("뒷주머니님과 대결중")
                .font(.pretendard(size: 14, weight: .bold))
              
              Spacer()
              
              Text("💸 30000원")
                .padding(.horizontal, 4)
                .background(ColorConstants.blue)
                .cornerRadius(4)
            }
            
            HStack {
              Text("일주일에 3만원으로 살아남기 👊🏻")
              
              Spacer()
            }
            .font(.pretendard(size: 16, weight: .bold))
          } // Header View
          .padding(16)
          .background(Color.white)
          .cornerRadius(10)
          .shadow(color: ColorConstants.gray2.opacity(0.1), radius: 4, y: 2)
          
          VStack(spacing: 8) {
            headerView(title: "인증사진", detail: "")
            
            Button(action: {
              self.imageList.append("example_food")
            }) {
              VStack {
                Image("icon_photo")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 18, height: 18)
                
                Text("이미지 등록하기")
                  .font(.pretendard(size: 16, weight: .semiBold))
              }
              .frame(maxWidth: .infinity)
              .padding(16)
              .background(Color.white)
              .cornerRadius(8)
              .shadow(color: ColorConstants.gray2.opacity(0.1), radius: 4, y: 2)
            }
            ScrollView(.horizontal, showsIndicators: false) {
              HStack {
                ForEach(0..<imageList.count, id: \.self) { imageIndex in
                  let imagePath = imageList[imageIndex]
                  Image(imagePath)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .overlay(
                      HStack {
                        Spacer()
                        
                        Image(systemName: "xmark.circle")
                      }
                        .onTapGesture {
                          imageList.remove(at: imageIndex)
                        }
                      ,
                      alignment: .top
                    )
                }
              }
            }
            
          }
          
          VStack(spacing: 8) {
            headerView(title: "금액", detail: "")
            
            textField(
              placeholder: "금액을 입력해주세요.",
              text: $moneyAmount,
              isActive: moneyAmount.isEmpty == false
            )
          }
          
          VStack(spacing: 8) {
            headerView(title: "제목", detail: "최소 5자 / 최대 15자")
            
            textField(
              placeholder: "제목을 입력해주세요.",
              text: $title,
              isActive: title.count > 5 && title.count < 16
            )
          }
          
          VStack(spacing: 8) {
            headerView(title: "내용", detail: "최소 30자 / 최대 100자")
            
            textField(
              placeholder: "지출 내용을 입력해주세요.",
              text: $content,
              isActive: content.count > 30 && content.count < 100
            )
          }
        }
        .padding(.horizontal, 24)
      }
      .padding(.bottom, 24)
      
      Spacer()
      
      Button(action: {
        showAlert = true
      }) {
        Text("인증하기")
          .font(.pretendard(size: 18, weight: .medium))
      }
      .padding(.vertical, 16)
      .frame(maxWidth: .infinity)
      .background(
        (
          moneyAmount.isEmpty || title.count < 5 || title.count > 15 || content.count < 30 || content.count > 100
        ) ? ColorConstants.gray5 : ColorConstants.primary
      )
      .foregroundColor(
        (
          moneyAmount.isEmpty || title.count < 5 || title.count > 15 || content.count < 30 || content.count > 100
        ) ? ColorConstants.gray4 : Color.black
      )
      .cornerRadius(8)
      .disabled(
        moneyAmount.isEmpty || title.count < 5 || title.count > 15 || content.count < 30 || content.count > 100
      )
      .padding(.horizontal, 24)
      .padding(.bottom, 16)
    }
    .alert(isPresent: $showAlert) {
      IGOAlertView {
        VStack {
          Image("icon_clap")
          
          Text("인증이 완료됐어요!\n마지막날까지 응원할께요")
            .multilineTextAlignment(.center)
            .font(.pretendard(size: 18, weight: .bold))
        }
      } primaryButton: {
        IGOAlertButton(
          title: Text("확인").foregroundColor(Color.black),
          color: ColorConstants.primary
        ) {
          showDetailList = true
          showAlert = false
          showWrite = false
        }
      }
    }
  }
  
  @ViewBuilder
  func headerView(title: String, detail: String) -> some View {
    HStack {
      Text(title)
        .font(.pretendard(size: 18, weight: .bold))
      
      Spacer()
      
      Text(detail)
        .font(.pretendard(size: 12, weight: .medium))
        .foregroundColor(ColorConstants.gray3)
    }
  }
  
  @ViewBuilder
  func textField(placeholder: String, text: Binding<String>, isActive: Bool) -> some View {
    TextField(placeholder, text: text)
      .textFieldStyle(.plain)
      .font(.pretendard(size: 16, weight: .medium))
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .background(
        isActive ? ColorConstants.primary7 : Color.white
      )
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(
            isActive ? ColorConstants.primary : ColorConstants.gray4
          )
      )
  }
}

struct ChallengeDetailView: View {
  @Binding var showDetail: Bool
  
  var body: some View {
    ZStack {
      Color.black.opacity(0.5)
        .edgesIgnoringSafeArea(.all)
      
      VStack(spacing: 8) {
        HStack {
          Spacer()
          
          Button(action: { }) {
            Image(systemName: "xmark")
              .resizable()
              .scaledToFit()
              .frame(width: 12, height: 12)
          }
        }
        .foregroundColor(.black)
        .padding(.horizontal, 24)
        .padding(.top, 24)
        
        HStack {
          VStack(alignment: .leading, spacing: 4) {
            Text("9월 24일 1일차")
              .font(.pretendard(size: 14, weight: .bold))
            
            Text("3000원 지출")
              .font(.pretendard(size: 16, weight: .medium))
              .padding(.horizontal, 4)
              .background(ColorConstants.blue)
              .cornerRadius(4)
          }
          
          Spacer()
        }
        .padding(.horizontal, 24)
        
        Divider()
          .padding(.horizontal, 24)
        
        Image("example_food")
          .resizable()
          .scaledToFill()
          .frame(
            width: 300, height: 300
          )
          .cornerRadius(8)
          .padding(.horizontal, 24)
        
        Divider()
          .padding(.horizontal, 24)
        
        HStack {
          Text("오늘은 도시락을 먹어서 지출은 커피값만! 🤟")
          
          Spacer()
        }
        .font(.pretendard(size: 16, weight: .bold))
        .padding(.horizontal, 24)
        
        Divider()
          .padding(.horizontal, 24)
        
        HStack {
          Text("의도치않게 커피값 지출...")
          
          Spacer()
        }
        .font(.pretendard(size: 14, weight: .bold))
        .padding(.horizontal, 24)
        
        HStack {
          Spacer()
          
          Button(action: { }) {
            Text("수정하기")
              .foregroundColor(ColorConstants.gray2)
              .font(.pretendard(size: 14, weight: .bold))
          }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 24)
      }
      .background(Color.white)
      .cornerRadius(8)
      .padding(.horizontal, 24)
    }
  }
}

struct ChallengeStateScene_Previews: PreviewProvider {
  static var previews: some View {
    ChallengeDetailView(showDetail: .constant(true))
  }
}
