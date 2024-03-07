//
//  SuggestFunctionViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/03/05.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import CommonFeature
import DesignSystem
import RxKeyboard
import RxSwift
import UIKit
import Utility

public final class WakMusicFeedbackViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var descriptionLabel1: UILabel!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var baseLineView: UIView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var completionButton: UIButton!

    let unPointColor: UIColor = DesignSystemAsset.GrayColor.gray200.color
    let pointColor: UIColor = DesignSystemAsset.PrimaryColor.decrease.color
    let textViewPlaceHolder: String = "내 답변"

    let disposeBag = DisposeBag()
    var viewModel: WakMusicFeedbackViewModel!
    lazy var input = WakMusicFeedbackViewModel.Input()
    lazy var output = viewModel.transform(from: input)

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyboardWhenTappedAround()
        responseViewbyKeyboard()
        bindRx()
        bindbuttonEvent()
    }

    public static func viewController(viewModel: WakMusicFeedbackViewModel) -> WakMusicFeedbackViewController {
        let viewController = WakMusicFeedbackViewController.viewController(
            storyBoardName: "Storage",
            bundle: Bundle.module
        )
        viewController.viewModel = viewModel
        return viewController
    }
}

extension WakMusicFeedbackViewController {
    private func configureUI() {
        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        titleLabel.setTextWithAttributes(kernValue: -0.5)

        closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)

        descriptionLabel1.text = "문의하실 내용을 적어주세요."
        descriptionLabel1.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        descriptionLabel1.textColor = DesignSystemAsset.GrayColor.gray900.color
        descriptionLabel1.setTextWithAttributes(kernValue: -0.5)

        textView.delegate = self
        textView.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        textView.placeholder = textViewPlaceHolder
        textView.placeholderColor = DesignSystemAsset.GrayColor.gray400.color
        textView.textColor = DesignSystemAsset.GrayColor.gray600.color
        textView.minHeight = 32.0
        textView.maxHeight = spaceHeight()

        baseLineView.backgroundColor = unPointColor

        self.completionButton.layer.cornerRadius = 12
        self.completionButton.clipsToBounds = true
        self.completionButton.isEnabled = false
        self.completionButton.setBackgroundColor(DesignSystemAsset.PrimaryColor.point.color, for: .normal)
        self.completionButton.setBackgroundColor(DesignSystemAsset.GrayColor.gray300.color, for: .disabled)
        self.completionButton.setAttributedTitle(NSMutableAttributedString(
            string: "완료",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium
                    .font(size: 18),
                .foregroundColor: DesignSystemAsset.GrayColor
                    .gray25.color,
                .kern: -0.5
            ]
        ), for: .normal)

        self.previousButton.layer.cornerRadius = 12
        self.previousButton.clipsToBounds = true
        self.previousButton.setBackgroundColor(DesignSystemAsset.GrayColor.gray400.color, for: .normal)
        self.previousButton.setAttributedTitle(NSMutableAttributedString(
            string: "이전",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium
                    .font(size: 18),
                .foregroundColor: DesignSystemAsset.GrayColor
                    .gray25.color,
                .kern: -0.5
            ]
        ), for: .normal)
    }

    private func bindbuttonEvent() {
        previousButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.navigationController?.popViewController(animated: true)
        })
        .disposed(by: disposeBag)

        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.dismiss(animated: true)
        })
        .disposed(by: disposeBag)

        completionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }

                let vc = TextPopupViewController.viewController(
                    text: "작성하신 내용을 등록하시겠습니까?",
                    cancelButtonIsHidden: false,
                    completion: { [weak self] in
                        self?.input.completionButtonTapped.onNext(())
                    }
                )
                self.showPanModal(content: vc)
            })
            .disposed(by: disposeBag)
    }

    private func bindRx() {
        textView.rx.text.orEmpty
            //      .skip(1)  //바인드 할 때 발생하는 첫 이벤트를 무시
            .distinctUntilChanged() // 연달아 같은 값이 이어질 때 중복된 값을 막아줍니다
            .bind(to: input.textString)
            .disposed(by: disposeBag)

        input.textString.subscribe(onNext: { [weak self] text in
            guard let self else { return }
            self.completionButton.isEnabled = !text.isWhiteSpace
        }).disposed(by: disposeBag)

        output.result.subscribe(onNext: { [weak self] res in
            guard let self else { return }
            let vc = TextPopupViewController.viewController(
                text: res.message ?? "오류가 발생했습니다.",
                cancelButtonIsHidden: true,
                completion: {
                    self.dismiss(animated: true)
                }
            )
            self.showPanModal(content: vc)
        })
        .disposed(by: disposeBag)
    }

    private func responseViewbyKeyboard() {
        RxKeyboard.instance.visibleHeight // 드라이브: 무조건 메인쓰레드에서 돌아감
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let self = self else {
                    return
                }
                self.textView.maxHeight = keyboardVisibleHeight == .zero ? self.spaceHeight() :
                    self.spaceHeight() - keyboardVisibleHeight + SAFEAREA_BOTTOM_HEIGHT() + 56
                // 키보드에서 바텀이 빼지면서 2번 빠짐

                DEBUG_LOG(
                    "\(self.spaceHeight()) \(SAFEAREA_BOTTOM_HEIGHT()) \(keyboardVisibleHeight)  \(self.spaceHeight() - keyboardVisibleHeight + SAFEAREA_BOTTOM_HEIGHT())  "
                )
                self.view.layoutIfNeeded() // 제약조건 바뀌었으므로 알려줌
            }).disposed(by: disposeBag)
    }

    func spaceHeight() -> CGFloat {
        return APP_HEIGHT() -
            (STATUS_BAR_HEGHIT() + SAFEAREA_BOTTOM_HEIGHT() + 48 + 20 + 28 + 16 + 66 + 10) // 마지막 10은 여유 공간
    }
}

extension WakMusicFeedbackViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.baseLineView.backgroundColor = self.pointColor
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        self.baseLineView.backgroundColor = self.unPointColor
    }
}
