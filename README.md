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

## 사용한 라이브러리 목록
![wak-라이브러리](https://github.com/wakmusic/wakmusic-iOS/assets/68860610/ece62563-e337-4591-84bf-7c8c982d2a54)


## 코딩 컨벤션

| 아이콘 | 코드 | 설명 |
| --- | --- | --- |
| 🎨 | :art: | 코드의 구조/형태 개선 |
| ⚡️ | :zap: | 성능 개선 |
| 🔥 | :fire: | 코드/파일 삭제 |
| 🐛 | :bug: | 버그 수정 |
| ✨ | :sparkles: | 새 기능 |
| 📝 | :memo: | 문서 추가/수정 |
| 💄 | :lipstick: | UI/스타일 파일 추가/수정 |
| 🎉 | :tada: | 프로젝트 시작/수정 |
| ✅ | :white_check_mark: | 테스트 추가/수정 |
| 🔒 | :lock: | 보안 이슈 수정 |
| 🔖 | :bookmark: | 릴리즈/버전 태그 |
| 👷 | :construction_worker: | CI 추가/수정 |
| ♻️ | :recycle: | 코드 리팩토링 |
| 🔧 | :wrench: | 구성 파일 추가/삭제 |
| 🔨 | :hammer: | 개발 스크립트 추가/수정 |
| 💩 | :poop: | 똥싼 코드 |
| ⏪ | :rewind: | 변경 내용 되돌리기 |
| 🔀 | :twisted_rightwards_arrows: | 브랜치 합병 |
| 📦 | :package: | 컴파일된 파일 추가/수정 |
| 👽 | :alien: | 외부 API 변화로 인한 수정 |
| 🚚 | :truck: | 리소스 이동, 이름 변경 |
| 📄 | :page_facing_up: | 라이센스 추가/수정 |
| 💡 | :bulb: | 주석 추가/수정 |
| 🗃 | :card_file_box: | 데이버베이스 관련 수정 |
| 🔊 | :loud_sound: | 로그 추가/수정 |
| 🧱 | :bricks: | 위 내용에 포함되지 않는 나머지 자질구레한 작업들 |

### 사용 예시

```markdown
🐛 :: 노래재생 페이지에서 조희수 보기가 정상적으로 작동되지 않는 버그 수정
 
💄 :: 아티스트 뷰 퍼블리싱 

✨ :: 아티스트 데이터 바인딩 & 서버와 연동

📝 :: 마크다운 문서에 Tuist generate 관련 문장 추가
```
