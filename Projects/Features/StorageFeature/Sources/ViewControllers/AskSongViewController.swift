//
//  SuggestFunctionViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/03/05.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import RxSwift
import RxKeyboard
import CommonFeature
import SafariServices

public final class AskSongViewController: UIViewController,ViewControllerFromStoryBoard {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var dotLabel1: UILabel!
    @IBOutlet weak var explainLabel1: UILabel!
    
    @IBOutlet weak var dotLabel2: UILabel!
    @IBOutlet weak var explainLabel2: UILabel!
    
    @IBOutlet weak var redirectWebButton: UIButton!
    
    @IBOutlet weak var descriptionLabel1: UILabel!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var baseLine1: UIView!
    
    
    @IBOutlet weak var descriptionLabel2: UILabel!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var baseLine2: UIView!
    
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var descriptionLabel3: UILabel!
    @IBOutlet weak var baseLine3: UIView!
    
    
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var descriptionLabel4: UILabel!
    @IBOutlet weak var baseLine4: UIView!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var completionButton: UIButton!
    
    
    let unPointColor:UIColor = DesignSystemAsset.GrayColor.gray200.color
    let pointColor:UIColor = DesignSystemAsset.PrimaryColor.decrease.color
    let placeHolder:String = "내 답변"
    
    let placeHolderAttributes = [
        NSAttributedString.Key.foregroundColor:  DesignSystemAsset.GrayColor.gray400.color,
        NSAttributedString.Key.font : DesignSystemFontFamily.Pretendard.medium.font(size: 16)
    ] // 포커싱 플레이스홀더 폰트 및 color 설정
    
    let disposeBag = DisposeBag()
    
    var viewModel:AskSongViewModel!
    lazy var input = AskSongViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    
    public override func viewDidLoad() {
        super.viewDidLoad()

       
        configureUI()
        
    }
    

    public static func viewController(viewModel:AskSongViewModel) -> AskSongViewController {
        let viewController = AskSongViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        
       
        viewController.viewModel = viewModel

        
        return viewController
    }

}


extension AskSongViewController {
    
    private func configureHeaderUI() {
        
        let explain1 = "이세돌 분들이 부르신걸 이파리분들이 개인소장용으로 일부공개한 영상을 올리길 원하시면 ‘은수저’님에게 왁물원 채팅으로 부탁드립니다."
        let explain2 = "왁뮤에 들어갈 수 있는 기준을 충족하는지 꼭 확인하시고 추가 요청해 주세요."
        let explain3 = "조회수가 이상한 경우는 반응 영상이 포함되어 있을 수 있습니다."
        
        dotLabel1.layer.cornerRadius = 2
        dotLabel1.clipsToBounds = true
        dotLabel1.backgroundColor = DesignSystemAsset.GrayColor.gray400.color
        
        dotLabel2.layer.cornerRadius = 2
        dotLabel2.clipsToBounds = true
        dotLabel2.backgroundColor = DesignSystemAsset.GrayColor.gray400.color
    
        
        redirectWebButton.setTitle("왁뮤 노래 포함 기준", for: .normal)
        redirectWebButton.setImage(DesignSystemAsset.Storage.blueArrowRight.image, for: .normal)
        redirectWebButton.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 12)
        redirectWebButton.titleLabel?.textColor = DesignSystemAsset.PrimaryColor.decrease.color
        
        
        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        titleLabel.text = viewModel.type == .add ? "노래 추가" : "노래 수정"
        
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.35
        
        explainLabel1.attributedText = NSMutableAttributedString(
            string: viewModel.type == .add ? explain1 : explain3,
            attributes: [.font: DesignSystemFontFamily.Pretendard.light.font(size: 12),
                         .foregroundColor: DesignSystemAsset.GrayColor.gray500.color,
                         .paragraphStyle: style]
        )
        
        explainLabel2.attributedText = NSMutableAttributedString(
            string: explain2,
            attributes: [.font: DesignSystemFontFamily.Pretendard.light.font(size: 12),
                         .foregroundColor: DesignSystemAsset.GrayColor.gray500.color,
                         .paragraphStyle: style]
        )
        
        dotLabel2.isHidden = viewModel.type == .edit
        explainLabel2.isHidden = viewModel.type == .edit
        redirectWebButton.isHidden = viewModel.type == .edit
        
    }
    
    private func configureUI(){
        
        
        
        hideKeyboardWhenTappedAround()
        configureHeaderUI()
       
        
        let descriptionLabels:[UILabel] = [descriptionLabel1,descriptionLabel2,descriptionLabel3,descriptionLabel4]
       
        let textFields:[UITextField] = [textField1,textField2,textField3]
        
        let baseLines:[UIView] = [baseLine1,baseLine2,baseLine3,baseLine4]
        
        
        for i in 0..<4 {
            
            var title:String = ""
            
            switch i {
                
            case 0 :
                title = "아티스트"
                
            case 1 :
                title = "노래 제목"
                
            case 2 :
                title = "유튜브 링크"
            
            case 3 :
                title = "내용"
                
            default :
                return
                
                
            }
            
            
            
            descriptionLabels[i].text = title
            descriptionLabels[i].font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
            descriptionLabels[i].textColor = DesignSystemAsset.GrayColor.gray900.color
            
            if i < 3 {
                
                textFields[i].attributedPlaceholder = NSAttributedString(string: placeHolder,attributes:placeHolderAttributes) //플레이스 홀더 설정
                
                textFields[i].font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
                
                textFields[i].textColor = DesignSystemAsset.GrayColor.gray600.color
            }
            
            
            baseLines[i].backgroundColor = unPointColor

            
            
        }
        
        
        

        textView.delegate = self
        textView.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        textView.placeholder = placeHolder
        textView.placeholderColor = DesignSystemAsset.GrayColor.gray400.color
        textView.textColor = DesignSystemAsset.GrayColor.gray600.color
        textView.minHeight = 32.0
        textView.maxHeight = spaceHeight()
       
        
        closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)
        self.completionButton.layer.cornerRadius = 12
        self.completionButton.clipsToBounds = true
        self.completionButton.isEnabled = false
        self.completionButton.setBackgroundColor(DesignSystemAsset.PrimaryColor.point.color, for: .normal)
        self.completionButton.setBackgroundColor(DesignSystemAsset.GrayColor.gray300.color, for: .disabled)
        self.completionButton.setAttributedTitle(NSMutableAttributedString(string:"완료",
                                                                     attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                                                                                  .foregroundColor: DesignSystemAsset.GrayColor.gray25.color ]), for: .normal)
        
        self.previousButton.layer.cornerRadius = 12
        self.previousButton.clipsToBounds = true
        self.previousButton.setBackgroundColor(DesignSystemAsset.GrayColor.gray400.color, for: .normal)
        self.previousButton.setAttributedTitle(NSMutableAttributedString(string:"이전",
                                                                     attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                                                                                  .foregroundColor: DesignSystemAsset.GrayColor.gray25.color ]), for: .normal)
        
        self.scrollView.delegate = self
        
        bindRx()
        bindbuttonEvent()
        responseViewbyKeyboard()
    }
    
    private func bindbuttonEvent(){
        

        
        previousButton.rx.tap.subscribe(onNext: { [weak self] in
            
            guard let self = self else{
                return
            }
            
            
            self.navigationController?.popViewController(animated: true)
            
        })
        .disposed(by: disposeBag)
        
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            
            guard let self = self else{
                return
            }
            
            self.dismiss(animated: true)
           
        })
        .disposed(by: disposeBag)
        
        
        let resultObservable = Observable<String>.merge(input.artistString.asObservable(),input.songTitleString.asObservable(),input.youtubeString.asObservable(),input.contentString.asObservable())
        
        completionButton.rx.tap
            .withLatestFrom(resultObservable)
            .subscribe(onNext: { [weak self] in
                
                
                DEBUG_LOG("\($0)")
                
                //TODO: 텍스트 팝업
                
            })
            .disposed(by: disposeBag)
        
        redirectWebButton.rx.tap
            .subscribe(onNext: { [weak self] () in
                guard let URL = URL(string: "https://whimsical.com/E3GQxrTaafVVBrhm55BNBS") else { return }
                
                let safari = SFSafariViewController(url: URL)
                self?.present(safari, animated: true)
            })
            .disposed(by: disposeBag)

            
    }
    
    
    private func bindRx(){
        
        textField1.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: input.artistString)
            .disposed(by: disposeBag)
        
        textField2.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: input.songTitleString)
            .disposed(by: disposeBag)
        
        textField3.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: input.youtubeString)
            .disposed(by: disposeBag)
        
        textView.rx.text.orEmpty
            .distinctUntilChanged() // 연달아 같은 값이 이어질 때 중복된 값을 막아줍니다
            .bind(to: input.contentString)
            .disposed(by: disposeBag)
    
        let tfEditingDidBegin1 = textField1.rx.controlEvent(.editingDidBegin)
        let tfEditingDidEnd1 = textField1.rx.controlEvent(.editingDidEnd)
        
        let mergeObservable1 = Observable.merge(tfEditingDidBegin1.map { UIControl.Event.editingDidBegin },
                                               tfEditingDidEnd1.map { UIControl.Event.editingDidEnd })
        
        let tfEditingDidBegin2 = textField2.rx.controlEvent(.editingDidBegin)
        let tfEditingDidEnd2 = textField2.rx.controlEvent(.editingDidEnd)
        
        let mergeObservable2 = Observable.merge(tfEditingDidBegin2.map { UIControl.Event.editingDidBegin },
                                               tfEditingDidEnd2.map { UIControl.Event.editingDidEnd })
        
        let tfEditingDidBegin3 = textField3.rx.controlEvent(.editingDidBegin)
        let tfEditingDidEnd3 = textField3.rx.controlEvent(.editingDidEnd)
        
        let mergeObservable3 = Observable.merge(tfEditingDidBegin3.map { UIControl.Event.editingDidBegin },
                                               tfEditingDidEnd3.map { UIControl.Event.editingDidEnd })
        

        mergeObservable1
            .asObservable()
            .subscribe(onNext: { [weak self] (event) in
                
                guard let self = self else{
                    return
                }
                
                
                if event ==  .editingDidBegin {
                    self.baseLine1.backgroundColor = self.pointColor
                    
                }
                
                else {
                    self.baseLine1.backgroundColor = self.unPointColor
                }
                
            })
            .disposed(by: disposeBag)
        
        mergeObservable2
            .asObservable()
            .subscribe(onNext: { [weak self] (event) in
                
                guard let self = self else{
                    return
                }
                
                if event ==  .editingDidBegin {
                    self.baseLine2.backgroundColor = self.pointColor
                    
                }
                
                else {
                    self.baseLine2.backgroundColor = self.unPointColor
                }
                
            })
            .disposed(by: disposeBag)
        
        mergeObservable3
            .asObservable()
            .subscribe(onNext: { [weak self] (event) in
                
                guard let self = self else{
                    return
                }
                
                if event ==  .editingDidBegin {
                    self.baseLine3.backgroundColor = self.pointColor
                    
                }
                
                else {
                    self.baseLine3.backgroundColor = self.unPointColor
                }
                
            })
            .disposed(by: disposeBag)
        
        
        Observable.zip(input.artistString, input.songTitleString, input.youtubeString, input.contentString)
            .subscribe(onNext: { [weak self] (artist,song,youtube,content) in
                
                guard let self = self else {
                    return
                }
                
                DEBUG_LOG("\(artist) \(song) \(youtube) \(content) ")
                
                if artist.isWhiteSpace || song.isWhiteSpace || youtube.isWhiteSpace || content.isWhiteSpace {
                    self.completionButton.isEnabled = false
                } else {
                    self.completionButton.isEnabled = true
                }
                
                
            })
            .disposed(by: disposeBag)
    }
    
    
    private func responseViewbyKeyboard(){
//        RxKeyboard.instance.visibleHeight //드라이브: 무조건 메인쓰레드에서 돌아감
//            .drive(onNext: { [weak self] keyboardVisibleHeight in
//
//                guard let self = self else {
//                    return
//                }
//
//                self.textView.maxHeight = keyboardVisibleHeight == .zero ?  self.spaceHeight() :
//                self.spaceHeight() - keyboardVisibleHeight + SAFEAREA_BOTTOM_HEGHIT() + 56
//               //키보드에서 바텀이 빼지면서 2번 빠짐
//
//                DEBUG_LOG("\(self.spaceHeight()) \(SAFEAREA_BOTTOM_HEGHIT()) \(keyboardVisibleHeight)  \(self.spaceHeight() - keyboardVisibleHeight + SAFEAREA_BOTTOM_HEGHIT())  ")
//
//
//                self.view.layoutIfNeeded() //제약조건 바뀌었으므로 알려줌
//
//
//            }).disposed(by: disposeBag)
        
    }
    
    func spaceHeight() -> CGFloat {
        
        
        return APP_HEIGHT() - ( STATUS_BAR_HEGHIT() + SAFEAREA_BOTTOM_HEGHIT()  + 48 +  20 + 28 + 16 +  66 + 10   ) // 마지막 10은 여유 공간
        
    }
    
}

extension AskSongViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollView.bounces = scrollView.contentOffset.y > 0
    }
}

extension AskSongViewController : UITextViewDelegate {



    public func textViewDidBeginEditing(_ textView: UITextView) {


        self.baseLine4.backgroundColor = self.pointColor


    }

    public func textViewDidEndEditing(_ textView: UITextView) {

        self.baseLine4.backgroundColor = self.unPointColor
    }

}
