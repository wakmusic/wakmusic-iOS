import Foundation

public enum PurposeType {
    case creation
    case updatePlaylistTitle
    case nickname
}

public extension PurposeType {
    var title: String {
        switch self {
        case .creation:
            return "리스트 만들기"
        case .updatePlaylistTitle:
            return "리스트 수정하기"
        case .nickname:
            return "닉네임 수정"
        }
    }

    var subTitle: String {
        switch self {
        case .creation:
            return "리스트 제목"
        case .updatePlaylistTitle:
            return "리스트 제목"
        case .nickname:
            return "닉네임"
        }
    }

    var btnText: String {
        switch self {
        case .creation:
            return "리스트 생성"
        case .updatePlaylistTitle:
            return "리스트 수정"
        case .nickname:
            return "완료"
        }
    }

    var textLimitCount: Int {
        switch self {
        case .creation, .updatePlaylistTitle:
            return 12
        case .nickname:
            return 12
        }
    }

    var placeHolder: String {
        switch self {
        case .creation, .updatePlaylistTitle:
            return "리스트 제목을 입력하세요."
        case .nickname:
            return "닉네임을 입력하세요."
        }
    }
}
