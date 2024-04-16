import Foundation

public enum PurposeType {
    case creation
    case edit
    case load
    case share
    case nickname
}

public extension PurposeType {
    var title: String {
        switch self {
        case .creation:
            return "리스트 만들기"
        case .edit:
            return "리스트 수정하기"
        case .load:
            return "리스트 가져오기"
        case .share:
            return "리스트 공유하기"
        case .nickname:
            return "닉네임 수정"
        }
    }

    var subTitle: String {
        switch self {
        case .creation:
            return "리스트 제목"
        case .edit:
            return "리스트 제목"
        case .load:
            return "리스트 코드"
        case .share:
            return "리스트 코드"
        case .nickname:
            return "닉네임"
        }
    }

    var btnText: String {
        switch self {
        case .creation:
            return "리스트 생성"
        case .edit:
            return "리스트 수정"
        case .load:
            return "가져오기"
        case .share:
            return "확인"
        case .nickname:
            return "완료"
        }
    }
}
