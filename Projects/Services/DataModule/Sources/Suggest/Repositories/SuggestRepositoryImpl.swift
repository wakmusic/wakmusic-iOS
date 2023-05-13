//
//  SuggestRepositoryImpl.swift
//  DataModuleTests
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DataMappingModule
import DomainModule
import ErrorModule
import NetworkModule
import DatabaseModule
import RxSwift

public struct SuggestRepositoryImpl: SuggestRepository {
    private let remoteSuggestDataSource: any RemoteSuggestDataSource
    
    public init(
        remoteSuggestDataSource: RemoteSuggestDataSource
    ) {
        self.remoteSuggestDataSource = remoteSuggestDataSource
    }
    
    public func reportBug(userID: String, nickname: String, attaches: [String], content: String) -> Single<ReportBugEntity> {
        remoteSuggestDataSource.reportBug(userID: userID, nickname: nickname, attaches: attaches, content: content)
    }
    
    public func suggestFunction(type: SuggestPlatformType, userID: String, content: String) -> Single<SuggestFunctionEntity> {
        remoteSuggestDataSource.suggestFunction(type: type, userID: userID, content: content)
    }
    
    public func modifySong(type: SuggestSongModifyType, userID: String, artist: String, songTitle: String, youtubeLink: String, content: String) -> Single<ModifySongEntity> {
        remoteSuggestDataSource.modifySong(type: type, userID: userID, artist: artist, songTitle: songTitle, youtubeLink: youtubeLink, content: content)
    }
    
    public func inquiryWeeklyChart(userID: String, content: String) -> Single<InquiryWeeklyChartEntity> {
        remoteSuggestDataSource.inquiryWeeklyChart(userID: userID, content: content)
    }
}
