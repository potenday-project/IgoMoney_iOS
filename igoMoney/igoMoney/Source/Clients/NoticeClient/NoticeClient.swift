//
//  NoticeClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Dependencies

struct Notice: Codable, Equatable {
  let ID: Int
  let title: String
  let content: String
  let createdDate: String
  
  enum CodingKeys: String, CodingKey {
    case ID = "newsId"
    case title
    case content
    case createdDate = "date"
  }
  
  static let `default`: [Notice] = [
    .init(ID: 0, title: "[공지] ‘챌린지 기능' 업데이트 안내", content: """
안녕하세요. 아이고머니입니다.

아이고머니 회원님께 더 나은 서비스를 제공할 수 있도록 ‘챌린지 기능'이 업데이트 될 예정입니다.

업데이트 예정일
2023년 11월 20일

업데이트 내용
앱 사용시 :

아이고머니는 앞으로도 회원님의 원활한 고객 경험을 위해 최선을 다할 것을 약속드립니다.

감사합니다.
""", createdDate: "2023-11-01"),
    .init(ID: 1, title: "[공지] ‘챌린지 기능' 업데이트 안내", content: """
안녕하세요. 아이고머니입니다.

아이고머니 회원님께 더 나은 서비스를 제공할 수 있도록 ‘챌린지 기능'이 업데이트 될 예정입니다.

업데이트 예정일
2023년 11월 20일

업데이트 내용
앱 사용시 :

아이고머니는 앞으로도 회원님의 원활한 고객 경험을 위해 최선을 다할 것을 약속드립니다.

감사합니다.
""", createdDate: "2023-11-01")
  ]
}

struct NoticeClient {
  var fetchAllNotice: @Sendable (_ lastID: Int) async throws -> [Notice]
}

extension NoticeClient: DependencyKey { }

extension DependencyValues {
  var noticeClient: NoticeClient {
    get { self[NoticeClient.self] }
    set { self[NoticeClient.self] = newValue }
  }
}
