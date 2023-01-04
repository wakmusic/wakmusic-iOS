import UIKit
import Utility
import DesignSystem
import RxCocoa
import RxSwift

public final class SearchViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var searchImageView:UIImageView!
    @IBOutlet weak var searchTextFiled:UITextField!
    @IBOutlet weak var cancelButton:UIButton!
    @IBOutlet weak var searchContentView:UIView!
    let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        DEBUG_LOG("\(Self.self) viewDidLoad")
        configureUI()

    }

    public static func viewController() -> SearchViewController {
        let viewController = SearchViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        return viewController
    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.view.endEditing(false)
    }
}


extension SearchViewController {
    private func configureUI() {
        
        //MARK: 검색 돋보기 이미지
        self.searchImageView.image = DesignSystemAsset.Search.search.image.withRenderingMode(.alwaysTemplate)
        self.searchImageView.tintColor = DesignSystemAsset.GrayColor.gray400.color
        //이미지 색 변경
        
        //MARK: 검색 텍스트 필드
        
        let headerFontSize:CGFloat = 20
        let unFocusedplaceHolderAttributes = [
            NSAttributedString.Key.foregroundColor: DesignSystemAsset.GrayColor.gray400.color,
            NSAttributedString.Key.font : DesignSystemFontFamily.Pretendard.medium.font(size: headerFontSize)
        ] // 언 포커싱 플레이스홀더 폰트 및 color 설정
        
        let focusedplaceHolderAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font : DesignSystemFontFamily.Pretendard.medium.font(size: headerFontSize)
        ] // 포커싱 플레이스홀더 폰트 및 color 설정
        
    
        
        self.searchTextFiled.font = DesignSystemFontFamily.Pretendard.medium.font(size: headerFontSize)
        self.searchTextFiled.textColor = .black
        // 텍스트 필드 폰트 및 색 설정
        self.searchTextFiled.attributedPlaceholder = NSAttributedString(string: "검색어를 입력하세요.",attributes:unFocusedplaceHolderAttributes) //플레이스 홀더 설정
        self.searchTextFiled.borderStyle = .none // 텍스트 필드 테두리 제거
        
        
        // MARK: 검색바 포커싱 시작 종료
        self.searchTextFiled.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe { [weak self]  _ in
                
                guard let self = self else {
                    return
                }
                
                self.view.backgroundColor = .white
                self.searchContentView.backgroundColor = .white
                
                self.searchTextFiled.textColor = .black
                self.searchTextFiled.attributedPlaceholder = NSAttributedString(string: "검색어를 입력하세요.",attributes:unFocusedplaceHolderAttributes) //플레이스 홀더 설정
                
                self.searchImageView.tintColor = DesignSystemAsset.GrayColor.gray400.color
                
            
                self.cancelButton.alpha = 0

            }.disposed(by: self.disposeBag)
    
        
        // MARK: 검색바 포커싱 시작
        self.searchTextFiled.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe { [weak self]  _ in
                
                guard let self = self else {
                    return
                }
                
                self.view.backgroundColor = DesignSystemAsset.PrimaryColor.point.color
                self.searchContentView.backgroundColor = DesignSystemAsset.PrimaryColor.point.color
                
                
                self.searchTextFiled.textColor = .white
                self.searchTextFiled.attributedPlaceholder = NSAttributedString(string: "검색어를 입력하세요.",attributes:focusedplaceHolderAttributes) //플레이스 홀더 설정
                
                
                self.searchImageView.tintColor = .white
                
                self.cancelButton.alpha = 1
                
            }.disposed(by: self.disposeBag)
        
        
        
        
        //MARK: 검색 취소 버튼
        self.cancelButton.titleLabel?.text = "취소"
        self.cancelButton.titleLabel?.font = DesignSystemFontFamily.Pretendard.bold.font(size: 15)
        self.cancelButton.layer.cornerRadius = 4
        self.cancelButton.layer.borderColor =  DesignSystemAsset.GrayColor.gray200.color.cgColor
        self.cancelButton.layer.borderWidth = 1
        self.cancelButton.backgroundColor = .white
        self.cancelButton.alpha = 0
        
        
        
        
        
    }
}
