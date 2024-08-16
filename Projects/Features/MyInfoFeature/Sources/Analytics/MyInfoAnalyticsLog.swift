import LogManager

enum MyInfoAnalyticsLog: AnalyticsLogType {
    /*
     내 정보 화면 보여짐 - common
     
     프로필 이미지를 누름
     프로필 변경 버튼을 누름
     닉네임 수정 버튼을 누름
     
     열매 뽑기 entry 버튼을 누름
     
     열매함 버튼을 누름
     자주 묻는 질문 버튼을 누름
     공지사항 버튼을 누름
     문의하기 버튼을 누름
     팀 소개 버튼을 누름
     설정 버튼을 누름
     */
    
    case clickProfileImage
    case clickProfileChangeButton
    case clickNicknameChangeButton
    case clickFruitStorageButton
    case clickFaqButton
    case clickNoticeButton
    case clickQnaButton
    case clickTeamButton
    case clickSettingButton
}
