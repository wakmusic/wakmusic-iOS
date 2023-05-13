//
//  SuggestRepository.swift
//  DomainModule
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule
import ErrorModule

public protocol SuggestRepository {
    func reportBug(userID: String, nickname: String, attaches: [String], content: String) -> Single<ReportBugEntity>
    func suggestFunction(type: SuggestPlatformType, userID: String, content: String) -> Single<SuggestFunctionEntity>
    func modifySong(type: SuggestSongModifyType,
                    userID: String,
                    artist: String,
                    songTitle: String,
                    youtubeLink: String,
                    content: String) -> Single<ModifySongEntity>
    func inquiryWeeklyChart(userID: String, content: String) -> Single<InquiryWeeklyChartEntity>
}
