import UIKit
import Utility
import DesignSystem
import RxCocoa
import RxSwift
import PanModal

public final class SearchViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var searchImageView:UIImageView!
    @IBOutlet weak var searchTextFiled:UITextField!
    @IBOutlet weak var cancelButton:UIButton!
    @IBOutlet weak var searchHeaderView:UIView!
    @IBOutlet weak var searchContentView:UIView!
    
    var viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        DEBUG_LOG("\(Self.self) viewDidLoad")
        configureUI()

    }
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let child = self.children.first as? BeforeSearchContentViewController else { return }
        child.view.frame = searchContentView.bounds
       
        //오차로 인하여 여기서 설정함
        /*
          frame != bounds
         - 두개 모두 x,y , width, height 을 갖고 있음
         - frame의 x,y는 부모의 중심 x,y을 가르킴
         - bounds의 x,y는 항상 자기자신을 중심으로 찍힘( 언제나 (0,0))
         
         */
        

        
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


//Extension


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
        
        
        rxBindTask()
        bindSubView()
        
}
       
    private func bindSubView()
    {
        let contentView = BeforeSearchContentViewController.viewController() //
        addChild(contentView)
        searchContentView.addSubview(contentView.view)
        contentView.didMove(toParent: self)
        contentView.delegate = self
        
        
    }
    
    
    //MARK: Rx 작업

    private func rxBindTask(){
        self.viewModel.output.isFoucused.subscribe { [weak self](res:Bool) in
            
            guard let self = self else {
                return
            }
            
            self.reactSearchHeader(res)
            
            
            
            
            //여기서 최근 검색어 로드 작업
            
         
            
        }.disposed(by: self.disposeBag)
        
        
        // MARK: 검색바 포커싱 시작 종료
      
        let editingDidBegin = searchTextFiled.rx.controlEvent(.editingDidBegin)
        let editingDidEnd = searchTextFiled.rx.controlEvent(.editingDidEnd)
        let editingDidEndOnExit = searchTextFiled.rx.controlEvent(.editingDidEndOnExit)
        

        let mergeObservable = Observable.merge(editingDidBegin.map { UIControl.Event.editingDidBegin },
                                               editingDidEnd.map { UIControl.Event.editingDidEnd }, editingDidEndOnExit.map { UIControl.Event.editingDidEndOnExit })

        mergeObservable
            .asObservable()
            .withLatestFrom(viewModel.input.textString) { ($0, $1) }
            .subscribe(onNext: { [weak self] (event,str) in
                        
            guard let self = self else {
                return
            }
                        
            if event == .editingDidBegin {
                self.viewModel.output.isFoucused.accept(true)
            }
            else if event == .editingDidEnd {
                self.viewModel.output.isFoucused.accept(false)
            }
            else
                {
                DEBUG_LOG("EditingDidEndOnExit")
                //유저 디폴트 저장
                if(str.isWhiteSpace)
                {
                    self.searchTextFiled.rx.text.onNext("")
                    let textPopupViewController = TextPopupViewController.viewController(
                        text: "검색어를 입려해주세요.",
                        cancelButtonIsHidden: true
                    )
                    let viewController: PanModalPresentable.LayoutType = textPopupViewController //
                    self.presentPanModal(viewController) //modal Show
                    
                }
                else
                {
                    PreferenceManager.shared.addRecentRecords(word: str)
                }
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
        
        self.viewModel.input.textString.subscribe { [weak self] (str:String) in
            
            guard let self = self else
            {
                return
            }
            
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
        self.searchHeaderView.backgroundColor = isfocused ? DesignSystemAsset.PrimaryColor.point.color : .white
        
        
        self.searchTextFiled.textColor = isfocused ? .white : .black
        self.searchTextFiled.attributedPlaceholder = NSAttributedString(string: "검색어를 입력하세요.",attributes:focusedplaceHolderAttributes) //플레이스 홀더 설정
        self.searchImageView.tintColor = isfocused ? .white : DesignSystemAsset.GrayColor.gray400.color
        
        self.cancelButton.alpha =  isfocused ? 1 : 0
    }
    
    
}

extension SearchViewController:BeforeSearchContentViewDelegate{
    func itemSelected(_ keyword: String) {
        searchTextFiled.rx.text.onNext(keyword)
        viewModel.input.textString.accept(keyword)
        viewModel.output.isFoucused.accept(false)
        PreferenceManager.shared.addRecentRecords(word: keyword)
        view.endEditing(true)
        
    }
    
    
}
