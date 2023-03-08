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


    
    var questionComponent: QuestionComponent {
        
        QuestionComponent(parent: self)
    }
    
    var suggestFunctionComponent:SuggestFunctionComponent {
        
        SuggestFunctionComponent(parent: self)
    }

    var wakMusicFeedbackComponent: WakMusicFeedbackComponent {
        
        WakMusicFeedbackComponent(parent: self)
    }
    
    var askSongComponent: AskSongComponent {
        
        AskSongComponent(parent: self)
    }
    
    var remoteQuestionDataSource: any RemoteQnaDataSource {
        shared {
            RemoteQnaDataSourceImpl(keychain: keychain)
        }
    }
    
    var questionRepository: any QnaRepository {
        shared {
            
            QnaRepositoryImpl(remoteQnaDataSource: remoteQnaDataSource)
        }
    }
 
}
