//
//  AppComponent+Suggest.swift
//  WaktaverseMusic
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DomainModule
import DataModule
import NetworkModule
import CommonFeature
import StorageFeature

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
    var bugReportComponent: BugReportComponent {
        BugReportComponent(parent: self)
    }
    
    var remoteSuggestDataSource: any RemoteSuggestDataSource {
        shared {
            RemoteSuggestDataSourceImpl(keychain: keychain)
        }
    }
    var suggestRepository: any SuggestRepository {
        shared {
            SuggestRepositoryImpl(remoteSuggestDataSource: remoteSuggestDataSource)
        }
    }
    var reportBugUseCase: any ReportBugUseCase{
        shared {
            ReportBugUseCaseImpl(suggestRepository: suggestRepository)
        }
    }
    var suggestFunctionUseCase: any SuggestFunctionUseCase{
        shared {
            SuggestFunctionUseCaseImpl(suggestRepository: suggestRepository)
        }
    }
    var modifySongUseCase: any ModifySongUseCase{
        shared {
            ModifySongUseCaseImpl(suggestRepository: suggestRepository)
        }
    }
    var inquiryWeeklyChartUseCase: any InquiryWeeklyChartUseCase{
        shared {
            InquiryWeeklyChartUseCaseImpl(suggestRepository: suggestRepository)
        }
    }
}
