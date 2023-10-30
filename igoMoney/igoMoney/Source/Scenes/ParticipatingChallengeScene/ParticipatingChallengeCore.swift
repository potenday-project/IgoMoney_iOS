//
//  ParticipatingChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct ParticipatingChallengeCore: Reducer {
    struct State: Equatable {
        var challenge: Challenge
        var challengeInformationState: ChallengeInformationCore.State
        
        init(challenge: Challenge) {
            self.challenge = challenge
            self.challengeInformationState = ChallengeInformationCore.State(challenge: challenge)
        }
    }
    
    enum Action: Equatable {
        
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
