//
//  ContractViewController.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import LogManager
import NVActivityIndicatorView
import PDFKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit
import Utility

public enum ContractType {
    case privacy
    case service
}

extension ContractType {
    var title: String {
        switch self {
        case .privacy:
            return "개인정보 처리방침"
        case .service:
            return "서비스 이용약관"
        }
    }

    var url: String {
        switch self {
        case .privacy:
            return "\(CDN_DOMAIN_URL())/document/privacy.pdf"
        case .service:
            return "\(CDN_DOMAIN_URL())/document/terms.pdf"
        }
    }
}

public final class ContractViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var fakeView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!

    var type: ContractType = .privacy
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌ \(Self.self) deinit")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindRx()
        loadPDF()
    }

    public static func viewController(type: ContractType) -> ContractViewController {
        let viewController = ContractViewController.viewController(storyBoardName: "Base", bundle: Bundle.module)
        viewController.type = type
        return viewController
    }
}

private extension ContractViewController {
    func bindRx() {
        Observable.merge(
            closeButton.rx.tap.map { _ in () },
            confirmButton.rx.tap.map { _ in () }
        )
        .withUnretained(self)
        .subscribe(onNext: { owner, _ in
            owner.dismiss(animated: true)
        })
        .disposed(by: disposeBag)
    }

    func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)

        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = DesignSystemAsset.PrimaryColor.point.color
        activityIndicator.startAnimating()

        confirmButton.setBackgroundColor(DesignSystemAsset.PrimaryColor.point.color, for: .normal)
        confirmButton.layer.cornerRadius = 12
        confirmButton.clipsToBounds = true
        confirmButton.setAttributedTitle(NSMutableAttributedString(
            string: "확인",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray25.color,
                .kern: -0.5
            ]
        ), for: .normal)

        titleLabel.text = type.title
        titleLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleLabel.setTextWithAttributes(kernValue: -0.5)
    }
}

private extension ContractViewController {
    func loadPDF() {
        DispatchQueue.global(qos: .default).async {
            guard let url = URL(string: self.type.url),
                  let document = PDFDocument(url: url) else {
                self.loadFailPDF()
                return
            }
            self.configurePDF(document: document)
        }
    }

    func configurePDF(document: PDFDocument) {
        DispatchQueue.main.async {
            let pdfView = PDFView(frame: self.fakeView.bounds)
            pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            pdfView.autoScales = true
            pdfView.displayMode = .singlePageContinuous
            pdfView.displayDirection = .vertical
            pdfView.document = document
            self.fakeView.addSubview(pdfView)
            self.activityIndicator.stopAnimating()
        }
    }

    func loadFailPDF() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.fakeView.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
            let warningView = WMWarningView(text: "파일을 불러오는 데 문제가 발생했습니다.")
            self.view.addSubview(warningView)
            warningView.snp.makeConstraints {
                $0.top.equalTo(self.view.frame.height / 3)
                $0.centerX.equalToSuperview()
            }
        }
    }
}
