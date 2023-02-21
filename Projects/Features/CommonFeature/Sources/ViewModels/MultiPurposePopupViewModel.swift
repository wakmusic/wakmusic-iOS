//
//  SearchViewModel.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/05.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import BaseFeature
import DomainModule
import DataMappingModule
import Utility




public final class MultiPurposePopupViewModel:ViewModelType {
   
    
    let disposeBag = DisposeBag()
    
    var type:PurposeType
    var shareCode:String?
    var playListKey:String?
    
    var createPlayListUseCase:CreatePlayListUseCase!
    var loadPlayListUseCase:LoadPlayListUseCase!
    var setUserNameUseCase:SetUserNameUseCase!
    

    public struct Input {
        let textString:BehaviorRelay<String> = BehaviorRelay(value: "")
        let pressConfirm:PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let isFoucused:BehaviorRelay<Bool> = BehaviorRelay(value:false)
        
        var resultDescription: PublishSubject<String> = PublishSubject()
    }

    public init(type:PurposeType,
                createPlayListUseCase:CreatePlayListUseCase,
                loadPlayListUseCase:LoadPlayListUseCase,
                setUserNameUseCase:SetUserNameUseCase) {
        

       
        print("✅ \(Self.self) 생성")
        self.type = type
        self.createPlayListUseCase = createPlayListUseCase
        self.loadPlayListUseCase = loadPlayListUseCase
        self.setUserNameUseCase = setUserNameUseCase
        
        
        
        
    }
    
    deinit{
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }
    
    public func transform(from input: Input) -> Output {
        
        var output = Output()
        
        
        input.pressConfirm
            .withLatestFrom(input.textString)
            .subscribe(onNext: { [weak self] (text:String) in
            
            guard let self = self else{
                return
            }
      
            switch self.type{
                
            case .creation:
                self.createPlayListUseCase.execute(title:text )
                    .subscribe(onError: { [weak self] (error) in
                        guard let self = self else { return }
                        output.resultDescription.onNext(error.asWMError.errorDescription ?? "")
                    })
                    .disposed(by: self.disposeBag)
            
            case .nickname:
                self.setUserNameUseCase.execute(name:text)
                    .subscribe(onSuccess: { result in
                        
                        if result.status != 200 {
                            return
                        }
                        
                        Utility.PreferenceManager.userInfo = Utility.PreferenceManager.userInfo?.update(displayName:AES256.encrypt(string: text))
                        
                    },onError: { [weak self] (error) in
                        guard let self = self else { return }
                        output.resultDescription.onNext(error.asWMError.errorDescription ?? "")
                    }).disposed(by: self.disposeBag)
            
            case .load:
                self.loadPlayListUseCase.execute(key: text)
                    .subscribe(onSuccess: {
                        DEBUG_LOG($0)
                    })
                    .disposed(by: self.disposeBag)
            

            default :
                DEBUG_LOG(input.textString.value)
            }
            
            
            
        }).disposed(by: disposeBag)
        
      
        
        return output
    }
    
    
    
}
