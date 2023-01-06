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
    
    var viewModel = SearchViewModel()
    
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
        self.searchTextFiled.rx.text.onNext("")
        self.view.endEditing(false)
    }
}


extension SearchViewController {
    
    
    private func configureUI() {
        
        // MARK:검색 돋보기 이미지
        self.searchImageView.image = DesignSystemAsset.Search.search.image.withRenderingMode(.alwaysTemplate)
        
        let headerFontSize:CGFloat = 20
        self.searchTextFiled.borderStyle = .none // 텍스트 필드 테두리 제거
        self.searchTextFiled.font = DesignSystemFontFamily.Pretendard.medium.font(size: headerFontSize)
        
        //MARK: 검색 취소 버튼
        self.cancelButton.titleLabel?.text = "취소"
        self.cancelButton.titleLabel?.font = DesignSystemFontFamily.Pretendard.bold.font(size: 15)
        self.cancelButton.layer.cornerRadius = 4
        self.cancelButton.layer.borderColor =  DesignSystemAsset.GrayColor.gray200.color.cgColor
        self.cancelButton.layer.borderWidth = 1
        self.cancelButton.backgroundColor = .white
        
        
        self.rxBindTask()
        
}
       
    
    
    //MARK: Rx 작업

    private func rxBindTask(){
        self.viewModel.output.isFoucused.subscribe { [weak self](res:Bool) in
            
            guard let self = self else {
                return
            }
            
            self.reactSearchHeader(res)
            
            
        }.disposed(by: self.disposeBag)
        
        
        // MARK: 검색바 포커싱 시작 종료
      
        let editingDidBegin = searchTextFiled.rx.controlEvent(.editingDidBegin)
        let editingDidEnd = searchTextFiled.rx.controlEvent(.editingDidEnd)
        

        let mergeObservable = Observable.merge(editingDidBegin.map { UIControl.Event.editingDidBegin },
                                                       editingDidEnd.map { UIControl.Event.editingDidEnd })

        mergeObservable
            .asObservable()
            .subscribe(onNext: { [weak self] (event) in
                        
            guard let self = self else {
                return
            }
                        
            if event == .editingDidBegin {
                self.viewModel.output.isFoucused.accept(true)
            }
            else if event == .editingDidEnd {
                self.viewModel.output.isFoucused.accept(false)
            }
            })
            .disposed(by: disposeBag)
        
        
        
        //textField.rx.text 하고 subscirbe하면 옵셔널 타입으로 String? 을 받아오는데,
        // 옵셔널 말고 String으로 받아오고 싶으면 orEmpty를 쓰자 -!
        self.searchTextFiled.rx.text.orEmpty
            .skip(1)
            .distinctUntilChanged() // 연달아 같은 값이 이어질 때 중복된 값을 막아줍니다
            .bind(to: self.viewModel.input.textString)
            .disposed(by: self.disposeBag)
        
        self.viewModel.input.textString.subscribe { (str:String) in
            
            if(str.isEmpty)
            {
                print("Empty")
            }
            
            
            
            else
            {
                print("str: \(str)")
            }
            
            
        }.disposed(by: self.disposeBag)
        
        
        
        
        
        
        
      

    }

    private func reactSearchHeader(_ isfocused:Bool)
    {
        let headerFontSize:CGFloat = 20
        
        let focusedplaceHolderAttributes = [
            NSAttributedString.Key.foregroundColor: isfocused ? UIColor.white : DesignSystemAsset.GrayColor.gray400.color,
            NSAttributedString.Key.font : DesignSystemFontFamily.Pretendard.medium.font(size: headerFontSize)
        ] // 포커싱 플레이스홀더 폰트 및 color 설정
        
        self.view.backgroundColor = isfocused ? DesignSystemAsset.PrimaryColor.point.color : .white
        self.searchContentView.backgroundColor = isfocused ? DesignSystemAsset.PrimaryColor.point.color : .white
        
        
        self.searchTextFiled.textColor = isfocused ? .white : .black
        self.searchTextFiled.attributedPlaceholder = NSAttributedString(string: "검색어를 입력하세요.",attributes:focusedplaceHolderAttributes) //플레이스 홀더 설정
        self.searchImageView.tintColor = isfocused ? .white : DesignSystemAsset.GrayColor.gray400.color
        
        self.cancelButton.alpha =  isfocused ? 1 : 0
    }
    
    
}
