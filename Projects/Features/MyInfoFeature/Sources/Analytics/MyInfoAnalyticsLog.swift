import LogManager

enum MyInfoAnalyticsLog: AnalyticsLogType {
    case clickProfileImage
    case clickProfileChangeButton
    case completeProfileChange
    case clickNicknameChangeButton
    case completeNicknameChange
    case clickFruitDrawEntryButton(location: FruitDrawEntryLocation)
    case clickFruitStorageButton
    case clickFaqButton
    case clickNoticeButton
    case clickInquiryButton
    case clickTeamButton
    case clickSettingButton
}

enum FruitDrawEntryLocation: String, AnalyticsLogEnumParametable {
    case myPage = "my_page"

    var description: String {
        self.rawValue
    }
}
