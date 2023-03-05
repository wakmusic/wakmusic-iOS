//
//  AppComponent+Search.swift
//  WaktaverseMusic
//
//  Created by yongbeomkwak on 2023/02/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DomainModule
import DataModule
import NetworkModule
import CommonFeature
import SignInFeature
import StorageFeature

//MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수  이름 같아야함


public extension AppComponent {

    
    var qnaComponent:  QnaComponent {
        
        QnaComponent(parent: self)
    }
    
    var qnaContentComponent:  QnaContentComponent {
        
        QnaContentComponent(parent: self)
    }
    
    var questionComponent: QuestionComponent {
        
        QuestionComponent(parent: self)
    }
    
    var suggestFunctionComponent:SuggestFunctionComponent {
        
        SuggestFunctionComponent(parent: self)
    }
    

    
    var remoteQnaDataSource: any RemoteQnaDataSource {
        shared {
            RemoteQnaDataSourceImpl(keychain: keychain)
        }
    }
    
    var qnaRepository: any QnaRepository {
        shared {
            
            QnaRepositoryImpl(remoteQnaDataSource: remoteQnaDataSource)
        }
    }
    
    
    var fetchQnaCategoriesUseCase: any FetchQnaCategoriesUseCase{
        shared {
            FetchQnaCategoriesUseCaseImpl(qnaRepository: qnaRepository)
        }
    }
    
    var fetchQnaUseCase: any FetchQnaUseCase {
        shared {
            FetchQnaUseCaseImpl(qnaRepository: qnaRepository)
        }
    }
    
 
}
