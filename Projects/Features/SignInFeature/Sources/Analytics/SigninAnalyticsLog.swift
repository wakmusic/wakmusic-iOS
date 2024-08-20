import LogManager

enum SigninAnalyticsLog: AnalyticsLogType {
    case clickTermsOfServiceButton
    case clickPrivacyPolicyButton
    case clickSocialLoginButton(type: SocialLoginType)
    case completeSocialLogin(type: SocialLoginType)

    enum SocialLoginType: String, AnalyticsLogEnumParametable {
        case naver
        case google
        case apple
    }
}
