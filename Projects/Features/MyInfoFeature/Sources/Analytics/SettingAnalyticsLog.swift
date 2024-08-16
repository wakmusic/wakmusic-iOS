import LogManager

enum SettingAnalyticsLog: AnalyticsLogType {
    /*
     설정 화면 보여짐 - common

     알림 설정 버튼을 누름
     서비스 이용약관 버튼을 누름
     개인정보 처리방침 버튼을 누름
     오픈소스 라이선스 버튼을 누름
     캐시 데이터 지우기 버튼을 누름
     로그아웃 버튼을 누름
     버전정보 버튼을 누름
     회원탈퇴 버튼을 누름
     */

    case clickNotificationButton
    case clickServiceInfoButton
    case clickOpensourceButton
    case clickRemoveCacheButton
    case clickLogoutButton
    case clickVersionButton
    case clickWithdrawButton
}
