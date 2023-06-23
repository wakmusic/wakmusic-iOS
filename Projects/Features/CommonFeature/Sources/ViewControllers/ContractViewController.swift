//
//  ContractViewController.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import RxSwift
import PDFKit
import DesignSystem
import NVActivityIndicatorView

public enum ContractType{
    case privacy
    case service
}

extension ContractType{
    var title:String{
        switch self{
        case .privacy:
            return "개인정보처리방침"
        case .service:
            return "서비스 이용약관"
        }
    }
    
    var url:String {
        switch self{
        case .privacy:
            return "\(BASE_IMAGE_URL())/static/document/privacy.pdf"
        case .service:
            return "\(BASE_IMAGE_URL())/static/document/terms.pdf"
        }
    }
}

public final class ContractViewController: UIViewController, ViewControllerFromStoryBoard {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var fakeView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    var type:ContractType = .privacy
    var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindRx()
    }
    
    deinit {
        DEBUG_LOG("❌ \(Self.self) deinit")
    }

    public static func viewController(type:ContractType) -> ContractViewController {
        let viewController = ContractViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        viewController.type = type
        return viewController
    }
}

extension ContractViewController{
    private func bindRx(){
        closeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
         
        confirmButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadPdf(document:PDFDocument){
        let pdfView = PDFView(frame: self.fakeView.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.document = document
        self.fakeView.addSubview(pdfView)
        activityIndicator.stopAnimating()
    }
    
    private func configureUI(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = DesignSystemAsset.PrimaryColor.point.color
        activityIndicator.startAnimating()
        
        confirmButton.setBackgroundColor(DesignSystemAsset.PrimaryColor.point.color, for: .normal)
        confirmButton.layer.cornerRadius = 12
        confirmButton.clipsToBounds = true
        confirmButton.setAttributedTitle(NSMutableAttributedString(
            string: "확인",
            attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                         .foregroundColor: DesignSystemAsset.GrayColor.gray25.color,
                         .kern: -0.5
            ]
        ), for: .normal)
        closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)
        
        titleLabel.text = type.title
        titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleLabel.setLineSpacing(kernValue: -0.5)
        
        DispatchQueue.global(qos: .default).async {
            if let url = URL(string: self.type.url), let document = PDFDocument(url: url) {
                DispatchQueue.main.async {
                    self.loadPdf(document: document) // UI 작업이라 main 스레드로
                }
            }
        }
    }
}
