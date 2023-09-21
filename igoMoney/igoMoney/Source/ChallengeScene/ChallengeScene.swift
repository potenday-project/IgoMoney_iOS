//
//  ChallengeScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct ChallengeScene: View {
    var body: some View {
        ZStack {
            Color("background_color")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    HStack {
                        Image("icon_text_main")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                        
                        Spacer()
                    }
                    .padding(24)
                    
                    VStack {
                        ForEach(1..<100) { index in
                            HStack {
                                Text(index.description)
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                    )
                }
            }
        }
    }
}

struct ChallengeScene_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeScene()
    }
}
