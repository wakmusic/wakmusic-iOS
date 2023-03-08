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


public enum SongRequestType {
    
    case add
    case edit
    
}


public final class AskSongViewModel:ViewModelType {

    var disposeBag = DisposeBag()
    var type:SongRequestType!
    

    public struct Input {
    
        var artistString:PublishRelay<String> = PublishRelay()
        var songTitleString:PublishRelay<String> = PublishRelay()
        var youtubeString:PublishRelay<String> = PublishRelay()
        var contentString:PublishRelay<String> = PublishRelay()
    
    }

    public struct Output {
        
    }

    public init(type:SongRequestType){
        
        DEBUG_LOG("✅ \(Self.self) 생성")
        self.type = type
     
    }
    
    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        
        
        
        return output
    }
}
