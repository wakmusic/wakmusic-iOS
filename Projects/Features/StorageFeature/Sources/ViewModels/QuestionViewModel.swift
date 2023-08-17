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

public enum MailState {
    
    case sent
    case notReady
    
    var message:String {
        
        switch self {
            
        case .sent:
            return "소중한 의견 감사합니다."
        case .notReady:
            return "메일 계정이 설정되어 있지 않습니다.\n설정 > Mail 계정을 설정해주세요."
        }
        
    }
    
    var buttonText:String {
        
        switch self {
            
        case .sent:
            return "확인"
        case .notReady:
            return "설정하러 가기"
        }
        
    }
    
    
    
}

public struct MailContent{
     
    let receiver:String = "contact@wakmusic.xyz"
    let title:String
    let body:String
}

public final class QuestionViewModel:ViewModelType {
    var disposeBag = DisposeBag()
    

    public struct Input {
    }

    public struct Output {
        var selectedIndex: PublishRelay<Int> = PublishRelay()
        var mailContent: BehaviorRelay<MailContent> = .init(value: MailContent(title: "버그 제보", body: "버그 제보 입니다."))
        var showPopUp: BehaviorRelay<Bool> = .init(value: false)
        var state:PublishRelay<MailState> = PublishRelay()
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
        return output
    }
}
