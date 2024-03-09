//
//  RemoteSuggestDataSourceImpl.swift
//  NetworkModule
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import APIKit
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation
import RxSwift

public final class RemoteSuggestDataSourceImpl: BaseRemoteDataSource<SuggestAPI>, RemoteSuggestDataSource {
    public func reportBug(
        userID: String,
        nickname: String,
        attaches: [String],
        content: String
    ) -> Single<ReportBugEntity> {
        request(.reportBug(userID: userID, nickname: nickname, attaches: attaches, content: content))
            .map(ReportBugResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func suggestFunction(
        type: SuggestPlatformType,
        userID: String,
        content: String
    ) -> Single<SuggestFunctionEntity> {
        request(.suggestFunction(type: type, userID: userID, content: content))
            .map(SuggestFunctionResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func modifySong(
        type: SuggestSongModifyType,
        userID: String,
        artist: String,
        songTitle: String,
        youtubeLink: String,
        content: String
    ) -> Single<ModifySongEntity> {
        request(.modifySong(
            type: type,
            userID: userID,
            artist: artist,
            songTitle: songTitle,
            youtubeLink: youtubeLink,
            content: content
        ))
        .map(ModifySongResponseDTO.self)
        .map { $0.toDomain() }
    }

    public func inquiryWeeklyChart(userID: String, content: String) -> Single<InquiryWeeklyChartEntity> {
        request(.inquiryWeeklyChart(userID: userID, content: content))
            .map(InquiryWeeklyChartResponseDTO.self)
            .map { $0.toDomain() }
    }
}
