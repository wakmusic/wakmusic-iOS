import UIKit
import CommonFeature
import DomainModule
import NeedleFoundation
import Utility
import DesignSystem
import RxCocoa
import RxSwift
import PanModal
import SnapKit
import RxKeyboard
import BaseFeature




public final class SearchViewController: BaseViewController, ViewControllerFromStoryBoard,ContainerViewType {

    @IBOutlet weak var searchImageView:UIImageView!
    @IBOutlet weak var searchTextFiled:UITextField!
    @IBOutlet weak var cancelButton:UIButton!
    @IBOutlet weak var searchHeaderView:UIView!
    @IBOutlet weak public var contentView:UIView!
    
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    var viewModel:SearchViewModel!
    let disposeBag = DisposeBag()
    var beforesearchComponent: BeforeSearchComponent!
    
    lazy var beforeVc =  beforesearchComponent.makeView()
    lazy var afterVc = AfterSearchViewController.viewController()
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        DEBUG_LOG("\(Self.self) viewDidLoad")
        configureUI()
       

    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // navigationController?.interactivePopGestureRecognizer?.delegate = nil // 현재 탭에서 화면이동이 일어날 시 , 빠져나올 때 swipe로 이동
        
    }
    
   
    
//    override public func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        //guard let child = self.children.first as? BeforeSearchContentViewController else { return }
//        //child.view.frame = searchContentView.bounds
//
//        guard let child = self.children.first as? AfterSearchViewController else { return }
//        child.view.frame = searchContentView.bounds
//
//        print("DidLayoutSubview")
//        //오차로 인하여 여기서 설정함
//        /*
//          frame != bounds
//         - 두개 모두 x,y , width, height 을 갖고 있음
//         - frame의 x,y는 부모의 중심 x,y을 가르킴
//         - bounds의 x,y는 항상 자기자신을 중심으로 찍힘( 언제나 (0,0))
//
//         */
//
//
//
//    }
    
    
   

    public static func viewController(
        viewModel:SearchViewModel,
        beforeSearchComponent:BeforeSearchComponent
    ) -> SearchViewController {
        
        let viewController = SearchViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        
        viewController.viewModel = viewModel
        viewController.beforesearchComponent = beforeSearchComponent
        
        return viewController
    }
    

    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.searchTextFiled.rx.text.onNext("")
        self.viewModel.input.textString.accept("")
        self.bindSubView(false)
        self.view.endEditing(true)
        self.viewModel.output.isFoucused.accept(false)
     
    }
}


//Extension


extension SearchViewController {
    
    
    private func configureUI() {
                
        // MARK:검색 돋보기 이미지
        self.searchImageView.image = DesignSystemAsset.Search.search.image.withRenderingMode(.alwaysTemplate)
        let headerFontSize:CGFloat = 16
        self.searchTextFiled.borderStyle = .none // 텍스트 필드 테두리 제거
        self.searchTextFiled.font = DesignSystemFontFamily.Pretendard.medium.font(size: headerFontSize)
        
        //MARK: 검색 취소 버튼
        self.cancelButton.titleLabel?.text = "취소"
        self.cancelButton.titleLabel?.font = DesignSystemFontFamily.Pretendard.bold.font(size: 12)
        self.cancelButton.layer.cornerRadius = 4
        self.cancelButton.layer.borderColor =  DesignSystemAsset.GrayColor.gray200.color.cgColor
        self.cancelButton.layer.borderWidth = 1
        self.cancelButton.backgroundColor = .white
        self.viewModel.output.isFoucused.accept(false)
        
        
        rxBindTask()
        self.add(asChildViewController: beforeVc)
        beforeVc.delegate = self
        
}
    
    private func bindSubView(_ afterSearch:Bool)
    {
        
        
        /*
         A:부모
         B:자식
         
         서브뷰 추가
         A.addChild(B)
         A.view.addSubview(B.view)
         B.didMove(toParent: A)
         
         
         서브뷰 삭제
         B.willMove(toParent: nil) // 제거되기 직전에 호출
         B.removeFromParent() // parentVC로 부터 관계 삭제
         B.view.removeFromSuperview() // parentVC.view.addsubView()와 반대 기능
        
         */
        

        
        if  let nowChildVc  = children.first as? BeforeSearchContentViewController{
            
            print("현재 :\(nowChildVc) 서치완료:  \(afterSearch)")
            
            if(afterSearch == false)
            {
                return
            }
            else
            {
                self.remove(asChildViewController: beforeVc)
                self.add(asChildViewController: afterVc)
            }
            
            
        }else if let nowChildVc = children.first as? AfterSearchViewController{
            print("현재 :\(nowChildVc) 서치완료:  \(afterSearch)")
            
            if(afterSearch == true)
            {
                return
            }
            else
            {
                self.remove(asChildViewController: afterVc)
                self.add(asChildViewController: beforeVc)
                beforeVc.delegate = self
            }
            
        }
        
    
    }
    
    
    
  
    
    
    //MARK: Rx 작업

    private func rxBindTask(){

        
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
                print("END DID Begin")
                self.viewModel.output.isFoucused.accept(true)
                self.bindSubView(false)
            }
            else if event == .editingDidEnd {
                print("END DID End")
//                self.viewModel.output.isFoucused.accept(false)
                //self.bindSubView(false)
            }
            else //검색 버튼 눌렀을 때
                {
                DEBUG_LOG("EditingDidEndOnExit")
                //유저 디폴트 저장
                if str.isWhiteSpace == true
                {
                    self.searchTextFiled.rx.text.onNext("")
                    let textPopupViewController = TextPopupViewController.viewController(
                        text: "검색어를 입력해주세요.",
                        cancelButtonIsHidden: true
                    )
                    self.showPanModal(content: textPopupViewController)
                }
                else
                {
                    PreferenceManager.shared.addRecentRecords(word: str)
                    self.bindSubView(true)
                    UIView.setAnimationsEnabled(false)
                    self.view.endEditing(true) //바인드 서브 뷰를 먼저 해야 tabMan tabBar가 짤리는 버그를 방지
                    UIView.setAnimationsEnabled(true)
                    
                }
                
                self.viewModel.output.isFoucused.accept(false)
                
            }
            })
            .disposed(by: disposeBag)
        
        
        
        //textField.rx.text 하고 subscirbe하면 옵셔널 타입으로 String? 을 받아오는데,
        // 옵셔널 말고 String으로 받아오고 싶으면 orEmpty를 쓰자 -!
        self.searchTextFiled.rx.text.orEmpty
            .skip(1)  //바인드 할 때 발생하는 첫 이벤트를 무시
            .distinctUntilChanged() // 연달아 같은 값이 이어질 때 중복된 값을 막아줍니다
            .bind(to: self.viewModel.input.textString)
            .disposed(by: self.disposeBag)
        
        
        
        self.viewModel.output.isFoucused
            .withLatestFrom(self.viewModel.input.textString) {($0,$1)}
            .subscribe(onNext: { [weak self] (focus:Bool,str:String) in
                
                  
                guard let self = self else
                {
                      return
                }
                self.reactSearchHeader(focus)
                //print("str:\(str.isEmpty) , \(focus)")
                 
                  
                self.cancelButton.alpha =  !str.isEmpty||focus ? 1 : 0
                
                
            }).disposed(by: disposeBag)
        
        
        
        RxKeyboard.instance.visibleHeight //드라이브: 무조건 메인쓰레드에서 돌아감
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                
                guard let self = self else {
                    return
                }
                
             
                //키보드는 바텀 SafeArea부터 계산되므로 빼야함
                let window: UIWindow? = UIApplication.shared.windows.first
                let safeAreaInsetsBottom: CGFloat = window?.safeAreaInsets.bottom ?? 0
                
                let tmp = keyboardVisibleHeight  - safeAreaInsetsBottom  - 49 //탭바 높이 추가 
                
                self.contentViewBottomConstraint.constant = tmp > 0 ? tmp  : 56
                self.view.layoutIfNeeded() //제약조건 바뀌었으므로 알려줌
                
                
            }).disposed(by: disposeBag)
            
        
            


    }

    private func reactSearchHeader(_ isfocused:Bool)
    {
        
        let headerFontSize:CGFloat = 16
        
        let focusedplaceHolderAttributes = [
            NSAttributedString.Key.foregroundColor: isfocused ? UIColor.white : DesignSystemAsset.GrayColor.gray400.color,
            NSAttributedString.Key.font : DesignSystemFontFamily.Pretendard.medium.font(size: headerFontSize)
        ] // 포커싱 플레이스홀더 폰트 및 color 설정
        
        self.searchHeaderView.backgroundColor = isfocused ? DesignSystemAsset.PrimaryColor.point.color : .white
        
        
        self.searchTextFiled.textColor = isfocused ? .white : .black
        self.searchTextFiled.attributedPlaceholder = NSAttributedString(string: "검색어를 입력하세요.",attributes:focusedplaceHolderAttributes) //플레이스 홀더 설정
        self.searchImageView.tintColor = isfocused ? .white : DesignSystemAsset.GrayColor.gray400.color
        
        
    }
    
    
}

extension SearchViewController:BeforeSearchContentViewDelegate{
    func itemSelected(_ keyword: String) {
        searchTextFiled.rx.text.onNext(keyword)
        viewModel.input.textString.accept(keyword)
        viewModel.output.isFoucused.accept(false)
        PreferenceManager.shared.addRecentRecords(word: keyword)
        self.bindSubView(true)
        
        
        UIView.setAnimationsEnabled(false)
        view.endEditing(true) //바인드 서브 뷰를 먼저 해야 tabMan tabBar가 짤리는 버그를 방지
        UIView.setAnimationsEnabled(true)
    }
    
    
}



