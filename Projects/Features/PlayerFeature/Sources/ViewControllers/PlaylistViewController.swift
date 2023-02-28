//
//  PlaylistViewController.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/28.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit
import Combine

public class PlaylistViewController: UIViewController {
    var viewModel: PlaylistViewModel!
    var playlistView: PlaylistView!
    var playState = PlayState.shared
    var subscription = Set<AnyCancellable>()
    
    init(viewModel: PlaylistViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("PlaylistViewController has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        playlistView = PlaylistView(frame: self.view.frame)
        self.view.addSubview(playlistView)
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}

private extension PlaylistViewController {
    private func bindViewModel() {
        let input = PlaylistViewModel.Input(closeButtonDidTapEvent: self.playlistView.dismissButton.tapPublisher)
        let output = self.viewModel.transform(from: input)
        
        output.willClosePlaylist.sink { [weak self] _ in
            self?.dismiss(animated: true)
        }.store(in: &subscription)
    }
}
