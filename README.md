<div align="center">

<img src="https://github.com/wakmusic/wakmusic-iOS/assets/68860610/ac5ae167-63df-4bc2-8917-297a6f674f19.png" width = "1200">

</div>

## WAKTAVERS MUSIC의 iOS Github 저장소 입니다.

매주 왁물원에서 만나보던 왁타버스 뮤직을 iOS 앱에서 들을 수 있다고?
왁타버스 뮤직을 이용하면 실시간 차트, 나만의 플래이리스트, 검색 기능 등 많은 기능을 사용할 수 있습니다!

## 다운로드

<a href='https://apps.apple.com/kr/app/id1641642735'><img alt='Available on the App Store' src='https://user-images.githubusercontent.com/67373938/227817078-7aab7bea-3af0-4930-b341-1a166a39501d.svg' height='60px'/></a> 
<a href='https://play.google.com/store/apps/details?id=com.waktaverse.music'><img alt='Available on the Play Store' src='https://user-images.githubusercontent.com/67373938/227817080-0c069757-4000-4e3e-919b-b062e667ecc4.svg' height='60px'/></a>

## iOS Developer

| iOS Hamp | 구구 | 케이 | 김대희 | 댕댕 |
| --- | --- | --- | --- | -- |
| <img src="https://avatars.githubusercontent.com/u/48616183?v=4" width="200px"/> | <img src="https://avatars.githubusercontent.com/u/37323252?v=4" width="200px"/> | <img src="https://avatars.githubusercontent.com/u/60254939?v=4" width="200px"/> | <img src= "https://avatars.githubusercontent.com/u/68860610?v=4" width="200px"/> | <img src= "https://avatars.githubusercontent.com/u/31872539?v=4" width="200px"/> | 
| [yongbeomkwak](https://github.com/yongbeomkwak) | [KangTaeHoon](https://github.com/KangTaeHoon) | [youn9k](https://github.com/youn9k) | [kimdaehee0824](https://github.com/kimdaehee0824) | [CoCoE1203](https://github.com/CoCoE1203) |

## iOS 모듈 구조도

![wak-다이어그램](https://github.com/wakmusic/wakmusic-iOS/assets/68860610/6b1f8e39-5d87-49cc-aed0-44934333bd71)

- 화살표는 모듈 간의 의존성을 표현하였습니다.
- 보라색 모듈은 화면의 UI와 비지니스 로직을 처리하는 Feature 모듈입니다. 
- 파란색 모듈은 네트워크 통신, local DB의 로직을 처리하는 Service 모듈입니다. clean architecture를 기반으로 layer를 설계하였습니다.
- 노란색 모듈은 프로젝트 전체에서 사용하는 Static Librar 입니다.

코딩 컨벤션
