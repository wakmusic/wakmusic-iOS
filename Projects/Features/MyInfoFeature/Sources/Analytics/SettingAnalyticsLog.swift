import LogManager

enum SettingAnalyticsLog: AnalyticsLogType {
    case clickNotificationButton
    case clickTermsOfServiceButton
    case clickPrivacyPolicyButton
    case clickOpensourceButton
    case clickRemoveCacheButton
    case completeRemoveCache(size: String)
    case clickLogoutButton
    case completeLogout
    case clickVersionButton
    case clickWithdrawButton
    case completeWithdraw
}
