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

//
//public struct NickNameInfo {
//    var description: String
//    var check: Bool
//}
//
//
//public final class NickNamePopupViewModel{
//
//    var disposeBag = DisposeBag()
//    
//    var input = Input()
//    var output = Output()
//    
//
//    public struct Input {
//        
//        var selectedIndex:BehaviorRelay<NickNameInfo> = BehaviorRelay(value: NickNameInfo(description: "알려주기", check: true))
//    
//    }
//
//    public struct Output {
//        var dataSource:BehaviorRelay<[NickNameInfo]> = BehaviorRelay(value: [NickNameInfo(description: "알려주기", check: true),NickNameInfo(description: "비공개", check: false),NickNameInfo(description: "가입안함", check: false)])
//    }
//
//    public init(
//
//    ) {
//        
//        DEBUG_LOG("✅ \(Self.self) 생성")
//     
//    }
//    
//    deinit {
//        DEBUG_LOG("❌ \(Self.self) 소멸")
//    }
//    
// 
//}
