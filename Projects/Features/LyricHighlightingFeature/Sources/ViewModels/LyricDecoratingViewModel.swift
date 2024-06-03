//
//  LyricDecoratingViewModel.swift
//  LyricHighlightingFeature
//
//  Created by KTH on 6/3/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import BaseFeature
import Foundation
import RxRelay
import RxSwift
import SongsDomainInterface
import Utility

final class LyricDecoratingViewModel: ViewModelType {
    public init(
        //        fetchArtistSongListUseCase: any FetchArtistSongListUseCase
    ) {
        //        self.fetchArtistSongListUseCase = fetchArtistSongListUseCase
    }

    public struct Input {}

    public struct Output {}

    public func transform(from input: Input) -> Output {
        return Output()
    }
}
