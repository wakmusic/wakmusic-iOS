//
//  AfterLoginStorageViewModel.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import Utility
import RxSwift
import RxRelay
import DomainModule
import BaseFeature
import KeychainModule
import MessageUI

public final class QuestionViewModel:ViewModelType {
    var disposeBag = DisposeBag()
    
    public struct Input {
        var selectedIndex: PublishSubject<Int> = PublishSubject()
        var mailComposeResult: PublishSubject<Result<MFMailComposeResult, Error>> = PublishSubject()
    }

    public struct Output {
        var mailSource: BehaviorRelay<InquiryType> = .init(value: .unknown)
        var showToast: PublishSubject<String> = PublishSubject()
    }

    public init(
    ) {
        DEBUG_LOG("✅ \(Self.self) 생성")
    }
    
    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        
        input.selectedIndex
            .map { (i: Int) -> InquiryType in
                return InquiryType(rawValue: i) ?? .unknown
            }
            .bind(to: output.mailSource)
            .disposed(by: disposeBag)
        
        input.mailComposeResult
            .map { (result: Result<MFMailComposeResult, Error>) -> String in
                switch result {
                case let .success(result):
                    DEBUG_LOG("MFMailComposeResult: \(result)")
                    return (result == .sent) ? "소중한 의견 감사합니다." : ""
                case let .failure(error):
                    return error.localizedDescription
                }
            }
            .bind(to: output.showToast)
            .disposed(by: disposeBag)

        return output
    }
}

enum InquiryType: Int {
    case reportBug = 0
    case suggestFunction
    case addSong
    case modifySong
    case weeklyChart
    case unknown
}

extension InquiryType {
    var receiver: String {
        switch self {
        default:
            return "contact@wakmusic.xyz"
        }
    }
    
    var title: String {
        switch self {
        case .reportBug:
            return "버그 제보"
        case .suggestFunction:
            return "기능 제안"
        case .addSong:
            return "노래 추가"
        case .modifySong:
            return "노래 수정"
        case .weeklyChart:
            return "주간차트 영상"
        case .unknown:
            return ""
        }
    }
    
    var body: String {
        switch self {
        case .reportBug:
            return """
                겪으신 버그에 대해 설명해 주세요.\n\n\n\n\n\n
            """
        case .suggestFunction:
            return """
                제안해 주고 싶은 기능에 대해 설명해 주세요.\n\n\n\n\n\n
            """
        case .addSong:
            return """
                · 이세돌 분들이 부르신걸 이파리분들이 개인소장용으로 일부공개한 영상을 올리길 원하시면 ‘은수저’님에게 왁물원 채팅으로 부탁드립니다.
                · 왁뮤에 들어갈 수 있는 기준을 충족하는지 꼭 확인하시고 추가 요청해 주세요.
                \n아티스트:\n\n노래 제목:\n\n유튜브 링크:\n\n내용:\n\n\n\n
            """
        case .modifySong:
            return """
                조회수가 이상한 경우는 반응 영상이 포함되어 있을 수 있습니다.
                \n아티스트:\n\n노래 제목:\n\n유튜브 링크:\n\n내용:\n\n\n\n
            """
        case .weeklyChart:
            return """
                문의하실 내용을 적어주세요.\n\n\n\n\n\n
            """
        case .unknown:
            return ""
        }
    }
    
    var suffix: String {
        switch self {
        default:
            return """
                -------------------------------------------
                * 자동으로 작성된 시스템 정보입니다. 원활한 문의를 위해서 삭제하지 말아주세요.\n
                왁타버스뮤직 v\(APP_VERSION())
                \(Device().modelName) / \(OS_NAME()) \(OS_VERSION())
                닉네임: \(AES256.decrypt(encoded: Utility.PreferenceManager.userInfo?.displayName ?? ""))
            """
        }
    }
}
