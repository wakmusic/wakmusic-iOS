import UIKit
import Utility
import DesignSystem

public final class SearchViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var searchImageView:UIImageView!
    @IBOutlet weak var searchTextFiled:UITextField!
    @IBOutlet weak var cancelButton:UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        DEBUG_LOG("\(Self.self) viewDidLoad")
        configureUI()

    }

    public static func viewController() -> SearchViewController {
        let viewController = SearchViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        return viewController
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
        let placeHolderAttributes = [
            NSAttributedString.Key.foregroundColor: DesignSystemAsset.GrayColor.gray400.color,
            NSAttributedString.Key.font : DesignSystemFontFamily.Pretendard.medium.font(size: headerFontSize)
        ] // 플레이스홀더 폰트 및 color 설정
        
        self.searchTextFiled.font = DesignSystemFontFamily.Pretendard.medium.font(size: headerFontSize)
        self.searchTextFiled.textColor = .black
        // 텍스트 필드 폰트 및 색 설정
        self.searchTextFiled.attributedPlaceholder = NSAttributedString(string: "검색어를 입력하세요.",attributes:placeHolderAttributes) //플레이스 홀더 설정
        self.searchTextFiled.borderStyle = .none // 텍스트 필드 테두리 제거
        
        
        //MARK: 검색 취소 버튼
        self.cancelButton.titleLabel?.text = "취소"
        self.cancelButton.titleLabel?.font = DesignSystemFontFamily.Pretendard.bold.font(size: 15)
        self.cancelButton.layer.cornerRadius = 4
        self.cancelButton.layer.borderColor =  DesignSystemAsset.GrayColor.gray200.color.cgColor
        self.cancelButton.layer.borderWidth = 1
        self.cancelButton.backgroundColor = .white
    }
}
