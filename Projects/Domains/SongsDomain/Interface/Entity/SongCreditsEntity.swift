//
//  SongCreditsEntity.swift
//  SongsDomain
//
//  Created by KTH on 5/14/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation

public struct SongCreditsEntity {
    init(
        vocal: String,
        featuring: String,
        original: String,
        producing: String,
        lyrics: String,
        relyrics: String,
        compose: String,
        arrange: String,
        mixing: String,
        mastering: String,
        session: String,
        chorus: String,
        vocalGuide: String,
        trainer: String
    ) {
        self.vocal = vocal
        self.featuring = featuring
        self.original = original
        self.producing = producing
        self.lyrics = lyrics
        self.relyrics = relyrics
        self.compose = compose
        self.arrange = arrange
        self.mixing = mixing
        self.mastering = mastering
        self.session = session
        self.chorus = chorus
        self.vocalGuide = vocalGuide
        self.trainer = trainer
    }

    public let vocal, featuring: String
    public let original: String
    public let producing, lyrics, relyrics, compose: String
    public let arrange, mixing, mastering, session: String
    public let chorus, vocalGuide, trainer: String
}
