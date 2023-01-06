//
//  PlayerViewController.swift
//  RootFeatureTests
//
//  Created by KTH on 2023/01/02.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem

public class PlayerViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var artistLabel: CustomLabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundBlurImageView: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var progressSlider: CustomSlider!
    @IBOutlet weak var currentPlayTimeLabel: CustomLabel!
    @IBOutlet weak var totalPlayTimeLabel: CustomLabel!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeLabel: CustomLabel!
    
    @IBOutlet weak var viewsImageView: UIImageView!
    @IBOutlet weak var viewsLabel: CustomLabel!
    
    @IBOutlet weak var addPlaylistImageView: UIImageView!
    @IBOutlet weak var addPlaylistLabel: CustomLabel!
    
    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var playlistLabel: CustomLabel!
    
    @IBOutlet weak var lyricsTableView: UITableView!
    
    var titleString: String = ""
    var artistString: String = ""
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        lyricsTableView.delegate = self
        lyricsTableView.dataSource = self
        configureUI()
    }
    public static func viewController() -> PlayerViewController {
        let viewController = PlayerViewController.viewController(storyBoardName: "Player", bundle: Bundle.module)
        return viewController
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        print("closeButtonAction")
    }
    @IBAction func repeatButtonAction(_ sender: Any) {
        print("repeatButtonAction")
    }
    @IBAction func prevButtonAction(_ sender: Any) {
        print("prevButtonAction")
    }
    @IBAction func playButtonAction(_ sender: Any) {
        print("playButtonAction")
    }
    @IBAction func nextButtonAction(_ sender: Any) {
        print("nextButtonAction")
    }
    @IBAction func shuffleButtonAction(_ sender: Any) {
        print("shuffleButtonAction")
    }
    @IBAction func likeButtonAction(_ sender: Any) {
        print("likeButtonAction")
    }
    @IBAction func addPlaylistButtonAction(_ sender: Any) {
        print("addPlaylistButtonAction")
    }
    @IBAction func playlistButtonAction(_ sender: Any) {
        print("playlistButtonAction")
    }
    
}

extension PlayerViewController {

    private func configureUI() {
        closeButton.setImage(DesignSystemAsset.Navigation.close.image, for: .normal)
        closeButton.setTitle("", for: .normal)
        repeatButton.setImage(DesignSystemAsset.Player.repeatOff.image, for: .normal)
        repeatButton.setTitle("", for: .normal)
        prevButton.setImage(DesignSystemAsset.Player.prevOn.image, for: .normal)
        prevButton.setTitle("", for: .normal)
        playButton.setImage(DesignSystemAsset.Player.playLarge.image, for: .normal)
        playButton.setTitle("", for: .normal)
        nextButton.setImage(DesignSystemAsset.Player.nextOn.image, for: .normal)
        nextButton.setTitle("", for: .normal)
        shuffleButton.setImage(DesignSystemAsset.Player.shuffleOff.image, for: .normal)
        shuffleButton.setTitle("", for: .normal)
        likeImageView.image = DesignSystemAsset.Player.likeOff.image
        likeLabel.text = "2.0만"
        viewsImageView.image = DesignSystemAsset.Player.views.image
        viewsLabel.text = "2.1만"
        //addPlaylistImageView.image = DesignSystemAsset.Player.musicAdd.image
        addPlaylistImageView.image = DesignSystemAsset.Chart.newPlaylistAdd.image
        addPlaylistLabel.text = "노래담기"
        playlistImageView.image = DesignSystemAsset.Player.playList.image
        playlistLabel.text = "재생목록"
        
        thumbnailImageView.image = DesignSystemAsset.Player.dummyThumbnailLarge.image
        // 백그라운드 배경
        backgroundBlurImageView.image = DesignSystemAsset.Player.dummyThumbnailLarge.image
        backgroundBlurImageView.layer.opacity = 0.6
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = backgroundBlurImageView.frame
        self.backgroundBlurImageView.addSubview(visualEffectView)
        // 테이블뷰
        lyricsTableView.backgroundColor = .clear
        lyricsTableView.rowHeight = 24
        // 플레이 버튼
        playButton.layer.shadowColor = CGColor(red: 8, green: 15, blue: 52, alpha: 0.08)
        playButton.layer.shadowOpacity = 1.0
        playButton.layer.shadowOffset = CGSize(width: 0, height: 8)
        playButton.layer.shadowRadius = 40
        
        // 슬라이더
        let circleSize: CGFloat = 8.0
        let circleImage: UIImage? = makeCircleWith(size: CGSize(width: circleSize, height: circleSize),
                                                  color: colorFromRGB(0x08DEF7))
        progressSlider.layer.cornerRadius = 1
        progressSlider.setThumbImage(circleImage, for: .normal)
        progressSlider.setThumbImage(circleImage, for: .highlighted)
        progressSlider.maximumTrackTintColor = colorFromRGB(0xD0D5DD) // 슬라이더 안지나갔을때 컬러 값
        
    }
    
    private func makeCircleWith(size: CGSize, color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension PlayerViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lyricsCell: LyricsCell = lyricsTableView.dequeueReusableCell(withIdentifier: "LyricsCell", for: indexPath) as? LyricsCell ?? LyricsCell()
        
        return lyricsCell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
