### 🔗 Link
[iGoMoney 데모 영상](https://www.youtube.com/watch?v=Uss5qsSTfJY)

### 💻 상세 내용
한동안 Z세대 사이에서 무지출챌린지가 크게 유행있었는데, 고물가 시대에 지출절약에 도전하는 트렌드를 반영햇습니다. 예전에 실제로 '만원의 행복' 이라는 예능이 있었는데, 이를 참고했고 다른사람과 경쟁 구도로 절약에 도전하면 의욕도 상승하고 재미요소를 더하였습니다.

1. 챌린지를 생성하고, 참여할 수 있습니다.
2. 챌린지 세부적으로 주제와 금액을 설정할 수 있습니다.
3. 사진을 통해서 금액을 인증할 수 있습니다.

### 🛠️ 사용 기술 및 라이브러리

- 화면 구현 : SwiftUI
- 화면 설계 : Figma
- 의존성 관리 도구 : SPM
- 아키텍처 : MVI (TCA)
- 비동기 프로그래밍 : Swift Concurrency

### 💡 깨달은 점

- **Swift Concurrency**에 대해서 학습하였고, 비동기 프로그래밍에 대한 Apple의 언어적 도구입니다.
- **TCA**는 PointFree에서 구축한 MVI 패턴에 대한 라이브러리입니다.

### 📝 상세 구현 내용

**STEP 1 기획 및 설계 (참여도 100%)**

- 팀원들과 함께 **서비스를 정의하고, 정리**하였습니다.
    ![설계도](https://github.com/potenday-project/IgoMoney_iOS/assets/52390923/58e6eb17-90e4-4f5f-ba7f-f9e4b0b75766)
  
- Figma를 통해서 **디자이너와 함께 논의**
    ![디자이너협업](https://github.com/potenday-project/IgoMoney_iOS/assets/52390923/7c7106bc-dc5f-43f6-ad96-fdf96dc62fcf)    

- 서버 개발자와 함께 **ERD 작성**
    ![서버 개발자](https://github.com/potenday-project/IgoMoney_iOS/assets/52390923/80a3e288-9191-40e6-bdae-81b28b35858c)

---

**STEP 3 iOS 개발 (참여도 100%)**

1. **온보딩 화면**

|온보딩|카카오 로그인|
|---|---|
|<img src="https://github.com/potenday-project/IgoMoney_iOS/assets/52390923/b7357353-9966-41f9-9f0d-1436e2b55ab5" width="300"/>|<img src="https://github.com/potenday-project/IgoMoney_iOS/assets/52390923/a0ab9b77-c6e8-40dd-9a37-3a1fd506a6db" width="300"/>|

주요 업무

- **소셜 로그인 (Kakao, Apple)** 구현
- **자동 로그인** 및 화면 전환
- 로그인 API와 연동

상세 내용

해당 화면은 앱을 실행하게 되면, 마주하게 되는 첫 화면입니다. 로그인에 필요한 **토큰을 검사**하고, 토큰에 대해서 검사한 후, 다음 화면으로 진행할 수 있게 됩니다.

고민 내용

- 자동 로그인을 구현하기 위해서 **KeyChain**을 활용하였습니다. 이때, 앱 내부에서 일어나게 되는 일이 아닌, 시스템 상에서 동작하는 작업이라고 생각하여서 외부 클라이언트 객체로 구현하게 되었습니다. 하지만, 실제 다양한 곳에서 동작하게 되고, 네트워크를 구현하기 위해서 내부적으로 Client 객체에 접근하게 되었습니다. 이를 해결하기 위해서 Static 메서드로 접근할 수 있도록 하였습니다.
- 화면 전환을 위해서 토큰의 유효성 검사, 닉네임 설정 검사를 모두 통과하여야 합니다. 로직을 구현하기 위해서 많은 고민을 하였습니다. 토큰에 대한 유효성 검사를 수행한 결과로 액션을 연쇄 호출하여서 닉네임 검사로 이어질 수 있도록 구현하여 문제를 해결하였습니다.

---

2. **회원가입 페이지**

|약관 동의|회원가입 1|회원가입 2|
|---|---|---|
|<img src="https://github.com/potenday-project/IgoMoney_iOS/assets/52390923/2afac3da-f0dc-4abb-9e33-02db473ffc24" width="300"/>|<img src="https://github.com/potenday-project/IgoMoney_iOS/assets/52390923/e0588d2b-bde1-461e-a31d-4d675bb90256" width="300"/>|<img src="https://github.com/potenday-project/IgoMoney_iOS/assets/52390923/1d005662-7055-4554-b061-b47004315955" width="300"/>|

주요 업무

- 서비스 약관 동의 페이지
- 닉네임 설정 페이지 구현
- 상황에 따른 닉네임 설정 설명 구현

상세 내용

토큰의 유효성은 검사되었지만, 닉네임 설정이 안되어 있는 경우 나오는 화면입니다. 닉네임이 설정되어 있지 않은 경우에는 약관 동의를 보지 못했을 가능성이 높다고 판단하여 약관 동의 후, 회원 가입을 진행할 수 있도록 하였습니다. 또한, 닉네임의 최소 길이와 중복 확인을 구현하였습니다.

고민 내용

- 화면 내에서 동일한 곳에서 상태에 따라서 변경되어야 하는 텍스트가 존재하였습니다. 닉네임을 작성하지 않은 경우, 닉네임을 작성하고 있는 경우, 닉네임 글자 수가 적은 경우, 닉네임 글자수가 많은 경우, 닉네임이 중복된 경우 등 5가지 이상의 경우에 따라서 텍스트를 변경하여야 했습니다. 닉네임 상태에 대해서 enum 타입을 정의하고, 입력에 따라서 Reducer 내부에서 **상태를 지속적으로 변경**할 수 있도록 하였습니다.

---

3. **챌린지 생성 화면**

|홈화면|챌린지 생성|챌린지 생성 2|
|---|---|---|
|<img src="https://github.com/potenday-project/IgoMoney_iOS/assets/52390923/c2080d35-f550-4318-a69d-02511f9ab678" width="300"/>|<img src="https://github.com/potenday-project/IgoMoney_iOS/assets/52390923/66602776-0b73-4ad9-b1b4-d0e29e4551e6" width="300"/>|<img src="https://github.com/potenday-project/IgoMoney_iOS/assets/52390923/2761ef9b-3f97-4dd8-9123-cbaf6ff281e1" width="300"/>|

주요 업무

- 챌린지 생성 화면
- 생성 API 연동

상세 내용

홈 화면에서 챌린지를 직접 생성하는 버튼을 눌러서 챌린지를 생성할 수 있는 공간으로 이동할 수 있습니다. 챌린지를 새로 생성하기 위한 화면에서는 특성과 글을 작성할 수 있습니다. 최소 조건들을 만족하는 경우에만 완료 버튼을 활성화하여서 잘못된 데이터가 저장될 수 없도록 하였습니다.

고민 내용

- 내용을 입력하는 창에 대해서 많은 고민을 하였습니다. SwiftUI 내의 TextEditor는 iOS 16.0 이상에서만 배경 색상을 변경할 수 있는 API를 제공합니다. 하지만, 요구사항에서는 조건의 충족되는 경우에 배경을 변경하여야 하였습니다. iOS 버전을 분기처리할 수 있는 `@available` 키워드를 통해서 iOS 16 미만의 경우에는 UITextView의 특성을 변경할 수 있도록 하였습니다.

---

4. 프로필 설정 화면

|프로필 설정|프로필 설정 2|
|---|---|
|<img src="https://github.com/potenday-project/IgoMoney_iOS/assets/52390923/3edbe964-8e45-4487-a80e-472ba9266e7e" width="300"/>|<img src="https://github.com/potenday-project/IgoMoney_iOS/assets/52390923/bfa0ee90-0e98-4690-9519-f219636be4aaa0ab9b77-c6e8-40dd-9a37-3a1fd506a6db" width="300"/>|

주요 업무

- 프로필 이미지 변경 API 연동
- 닉네임 중복 확인 API 연동
- 프로필 업데이트 API 연동

상세 내용

사용자 프로필을 수정할 수 있는 화면입니다. 프로필 이미지 데이터를 로드한 후, 화면에 보여줄 수 있습니다. 프로필 이미지는 이미지 선택창을 통해서 이미지를 변경할 수 있습니다. 사용자 닉네임은 새로운 닉네임을 감지하고, 닉네임이 변경된 경우에는 다시 중복확인을 할 수 있습니다.

고민 내용

- `AsyncImage` 타입 미지원으로 인해서 네트워크에 존재하는 이미지를 불러오기 위해서 어떤 방법을 활용할 지 고민하였습니다. UIKit과 UIRepresentable 프로토콜을 활용하는 방법을 사용하려고 하였습니다. 하지만, Path가 변경되는 경우에 데이터를 다시 불러올 수 없었기 때문에 사용하지 못했습니다. SwiftUI와 Reducer를 통해서 **일반화된 타입**으로 구현하였습니다.
- 사용자의 닉네임은 회원가입 화면에서도 활용하고 있습니다. 보일러 플레이트 코드 작성을 줄이기 위해서 재사용을 고민하였습니다. 기존에는 재사용을 할 수 없도록 닉네임과 관련된 화면 전체 Reducer에 포함되어 있던 것을 닉네임 중복만 확인하는 Reducer를 구현하여서 화면 전체의 Reducer들이 소유할 수 있도록 하였습니다.

### 📚 프로젝트 관련 블로그 포스팅

> [Swift Concurrency 맛보기 & 맛 평가](https://devmin97.tistory.com/entry/Swift-Concurrency-맛보기-맛-평가)
> 
> [Swift Concurrency (2) - Behind Scene](https://devmin97.tistory.com/entry/Swift-Concurrency-2-Behind-Scene)
> 
> [TCA 기본](https://devmin97.tistory.com/entry/TCA-기본)
> 
> [TCA - 네트워크 요청하기](https://devmin97.tistory.com/entry/TCA-네트워크-요청하기)
> 
