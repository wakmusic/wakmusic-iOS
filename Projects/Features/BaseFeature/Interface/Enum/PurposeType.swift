import Foundation

public enum PurposeType {
    case creation
    case updatePlaylistTile
    case nickname
}

public extension PurposeType {
    var title: String {
        switch self {
        case .creation:
            return "리스트 만들기"
        case .updatePlaylistTile:
            return "리스트 수정하기"
        case .nickname:
            return "닉네임 수정"
        }
    }

    var subTitle: String {
        switch self {
        case .creation:
            return "리스트 제목"
        case .updatePlaylistTile:
            return "리스트 제목"
        case .nickname:
            return "닉네임"
        }
    }

    var btnText: String {
        switch self {
        case .creation:
            return "리스트 생성"
        case .updatePlaylistTile:
            return "리스트 수정"
        case .nickname:
            return "완료"
        }
    }
}
