//
//  PlaylistViewModel.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/28.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import Combine
import BaseFeature

final class PlaylistViewModel: ViewModelType {
    struct Input {
        let closeButtonDidTapEvent: AnyPublisher<Void, Never>
        
    }
    struct Output {
        var willClosePlaylist = PassthroughSubject<Bool, Never>()
    }
    
    private var subscription = Set<AnyCancellable>()
    
    init() {
        print("✅ PlaylistViewModel 생성")
    }
    
    deinit {
        print("❌ PlaylistViewModel deinit")
    }
    
    func transform(from input: Input) -> Output {
        let output = Output()
        
        input.closeButtonDidTapEvent.sink { _ in
            output.willClosePlaylist.send(true)
        }.store(in: &subscription)
        
        return output
    }
    
    func thumbnailURL(from id: String) -> String {
        return "https://i.ytimg.com/vi/\(id)/hqdefault.jpg"
    }
}
