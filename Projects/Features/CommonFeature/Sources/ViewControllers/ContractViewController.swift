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
            return "https://static.wakmusic.xyz/static/document/privacy.pdf"
        case .service:
            return "https://static.wakmusic.xyz/static/document/terms.pdf"
        }
    }
}

public final class ContractViewController: UIViewController, ViewControllerFromStoryBoard {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var fakeView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var type:ContractType = .privacy
    var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

        // Do any additional setup after loading the view.
    }
    deinit {
        DEBUG_LOG("\(Self.self) deinit")
        
    }
    

    public static func viewController(type:ContractType) -> ContractViewController {
        let viewController = ContractViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        
     
        viewController.type = type
        
        return viewController
    }

}


extension ContractViewController{
    private func configureUI(){
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        confirmButton.layer.cornerRadius = 12
        confirmButton.clipsToBounds = true
        confirmButton.setAttributedTitle(NSMutableAttributedString(string:"확인",
                                                                attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                                                                             .foregroundColor: DesignSystemAsset.GrayColor.gray25.color ]), for: .normal)
        

        confirmButton.setBackgroundColor(DesignSystemAsset.PrimaryColor.point.color, for: .normal)
        
        
        closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)
        
        
        titleLabel.text = type.title
        titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        

    
        DispatchQueue.global(qos: .default).async {
            
            if let url = URL(string: self.type.url), let document = PDFDocument(url: url) {
                
                DispatchQueue.main.async {
                    self.loadPdf(document: document) // UI 작업이라 main 스레드로
                }
                
                
            }
        }
        
            
        
        
        bindRx()
    }
    
    private func bindRx(){
        
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            
            guard let self =  self else {
                return
            }
            
            self.dismiss(animated: true)
            
            
            
        }).disposed(by: disposeBag)
         
        confirmButton.rx.tap.subscribe(onNext: { [weak self] in
            
            guard let self =  self else {
                return
            }
            
            
            self.dismiss(animated: true )
            
        }).disposed(by: disposeBag)
        
        
    }
    
    private func loadPdf(document:PDFDocument){
        let pdfView = PDFView(frame: self.fakeView.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.fakeView.addSubview(pdfView)

        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.document = document
    }
}
