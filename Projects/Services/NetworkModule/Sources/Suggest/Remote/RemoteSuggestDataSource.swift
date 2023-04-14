//
//  RemoteSuggestDataSource.swift
//  NetworkModule
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift

public protocol RemoteSuggestDataSource {
    func reportBug(userID: String, nickname: String, attaches: [Data], content: String) -> Single<ReportBugEntity>
    func suggestFunction(type: SuggestPlatformType, userID: String, content: String) -> Single<SuggestFunctionEntity>
    func modifySong(type: SuggestSongModifyType,
                    userID: String,
                    artist: String,
                    songTitle: String,
                    youtubeLink: String,
                    content: String) -> Single<ModifySongEntity>
    func inquiryWeeklyChart(userID: String, content: String) -> Single<InquiryWeeklyChartEntity>
}
