import BaseFeature
import BaseFeatureInterface
import DesignSystem
import KeychainModule
import Pageboy
import PanModal
import ReactorKit
import RxSwift
import SignInFeatureInterface
import Tabman
import UIKit
import Utility

final class StorageViewController: TabmanViewController, ViewControllerFromStoryBoard, EqualHandleTappedType,
    StoryboardView {
    
    private enum Color {
        static let gray = DesignSystemAsset.GrayColor.gray400.color

        static let point = DesignSystemAsset.PrimaryColor.point.color
    }
    
    
    private enum ButtonAttributed {
        static let edit = NSMutableAttributedString(
            string: "편집",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.bold.font(size: 12),
                .foregroundColor: Color.gray
            ]
        )

        static let save = NSMutableAttributedString(
            string: "완료",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.bold.font(size: 12),
                .foregroundColor: Color.point
            ]
        )
    }
    
    typealias Reactor = StorageReactor

    var disposeBag: DisposeBag = DisposeBag()

    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var myPlayListFakeView: UIView!
    @IBOutlet weak var favoriteFakeView: UIView!

    private var viewControllers: [UIViewController] = [UIViewController(), UIViewController()]

    public var bottomSheetView: BottomSheetView!
    private var myPlayListComponent: MyPlayListComponent!
    private var multiPurposePopUpFactory: MultiPurposePopUpFactory!
    private var favoriteComponent: FavoriteComponent!
    private var textPopUpFactory: TextPopUpFactory!
    private var signInFactory: SignInFactory!

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    /// 탭맨 페이지 변경 감지 함수
    override public func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        didScrollToPageAt index: TabmanViewController.PageIndex,
        direction: PageboyViewController.NavigationDirection,
        animated: Bool
    ) {
//        let state = EditState(isEditing: false, force: true)
//
//        if index == 0 {
//            guard let vc1 = self.viewControllers[0] as? MyPlayListViewController else {
//                return
//            }
//            vc1.output.state.accept(state) // 이제 돌아오는 곳을 편집 전 으로 , 이게 밑에 bindEditButtonVisable() 에 연관 됨
//            editButton.isHidden = (vc1.output.dataSource.value.first?.items ?? []).isEmpty
//
//        } else {
//            guard let vc2 = self.viewControllers[1] as? FavoriteViewController else {
//                return
//            }
//            vc2.output.state.accept(state)
//            editButton.isHidden = (vc2.output.dataSource.value.first?.items ?? []).isEmpty
//        }
        // output.state.accept(state)
    }

    public static func viewController(
        reactor: StorageReactor,
        myPlayListComponent: MyPlayListComponent,
        multiPurposePopUpFactory: MultiPurposePopUpFactory,
        favoriteComponent: FavoriteComponent,
        textPopUpFactory: TextPopUpFactory,
        signInFactory: SignInFactory

    ) -> StorageViewController {
        let viewController = StorageViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)

        viewController.reactor = reactor

        viewController.myPlayListComponent = myPlayListComponent
        viewController.multiPurposePopUpFactory = multiPurposePopUpFactory
        viewController.favoriteComponent = favoriteComponent
        viewController.viewControllers = [myPlayListComponent.makeView(), favoriteComponent.makeView()]
        viewController.textPopUpFactory = textPopUpFactory
        viewController.signInFactory = signInFactory
        return viewController
    }

    deinit {
        DEBUG_LOG("❌ \(Self.self)")
    }

    func bind(reactor: StorageReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
}

extension StorageViewController {
    func bindAction(reactor: Reactor) {
        
        editButton.rx
            .tap
            .withUnretained(self)
            .withLatestFrom(Utility.PreferenceManager.$userInfo){($0.0,$1)}
            .bind { (owner,userInfo) in
                
                guard let userInfo = userInfo else {
                    reactor.action.onNext(.showLoginAlert) // 로그인 화면 팝업
                    return
                }
            
                reactor.action.onNext(.tabDidEditButton)
            }
            .disposed(by: disposeBag)
        
        
        saveButton.rx
            .tap
            .map { Reactor.Action.saveButtonTap}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }

    func bindState(reactor: Reactor) {
        
        let sharedState = reactor.state.share(replay: 1)
        
        sharedState.map(\.isEditing)
            .withUnretained(self)
            .bind { owner,flag in

                owner.isScrollEnabled = !flag //  편집 시 , 옆 탭으로 swipe를 막기 위함
                owner.editButton.isHidden = flag
                owner.saveButton.isHidden = !flag
                
                 if flag {
                     owner.myPlayListFakeView.isHidden = owner.currentIndex == 0
                     owner.favoriteFakeView.isHidden = owner.currentIndex == 1
                 } else {
                     owner.myPlayListFakeView.isHidden = true
                     owner.favoriteFakeView.isHidden = true
                 }
                
                
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isShowLoginAlert)
            .skip(1)
            .withUnretained(self)
            .bind { (owner,_) in
            
             
                
                guard let vc = owner.textPopUpFactory.makeView(
                    text: "로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?",
                    cancelButtonIsHidden: false,
                    allowsDragAndTapToDismiss: nil,
                    confirmButtonText: nil,
                    cancelButtonText: nil,
                    completion: {
                        let loginVC = owner.signInFactory.makeView()
                        owner.present(loginVC, animated: true)
                    },
                    cancelCompletion: {
                        
                    }
                ) as? TextPopupViewController else {
                    return
                }
                
                owner.showPanModal(content: vc)
                
                
                
            }
            .disposed(by: disposeBag)
        
        
    }
}


 extension StorageViewController {
     
     private func bindRx() {
//         output.state.subscribe { [weak self] state in
//             guard let self = self else {
//                 return
//             }
//
//             let attr = NSMutableAttributedString(
//                 string: state.isEditing ? "완료" : "편집",
//                 attributes: [
//                     .font: DesignSystemFontFamily.Pretendard.bold.font(size: 12),
//                     .foregroundColor: state.isEditing ? DesignSystemAsset.PrimaryColor
//                         .point.color : DesignSystemAsset.GrayColor.gray400.color
//                 ]
//             )
//             self.editButton.layer.borderColor = state.isEditing ? DesignSystemAsset.PrimaryColor.point.color
//                 .cgColor : DesignSystemAsset.GrayColor.gray300.color.cgColor
//             self.editButton.setAttributedTitle(attr, for: .normal)
//             self.isScrollEnabled = !state.isEditing //  편집 시 , 옆 탭으로 swipe를 막기 위함
//           
//
//             if state.isEditing {
//                 self.myPlayListFakeView.isHidden = self.currentIndex == 0
//                 self.favoriteFakeView.isHidden = self.currentIndex == 1
//             } else {
//                 self.myPlayListFakeView.isHidden = true
//                 self.favoriteFakeView.isHidden = true
//             }
//         }.disposed(by: disposeBag)
//
//         editButton.rx.tap
//             .withLatestFrom(output.state)
//             .map { EditState(isEditing: !$0.isEditing, force: $0.force) }
//             .do(onNext: { [weak self] (state: EditState) in
//                 guard let self = self else {
//                     return
//                 }
//
//                 // 프로필 편집 팝업을 띄운 상태에서 리스트 편집 시 > 프로필 편집 팝업을 제거
//                 if self.editSheetView != nil {
//                     self.hideEditSheet()
//                 }
//
//                 let nextState = EditState(isEditing: state.isEditing, force: false)
//
//                 if self.currentIndex ?? 0 == 0 {
//                     guard let vc = self.viewControllers[0] as? MyPlayListViewController else {
//                         return
//                     }
//                     vc.output.state.accept(nextState)
//                 } else {
//                     guard let vc = self.viewControllers[1] as? FavoriteViewController else {
//                         return
//                     }
//                     vc.output.state.accept(nextState)
//                 }
//             })
//             .bind(to: output.state)
//             .disposed(by: disposeBag)
//
//         profileButton.rx.tap.subscribe(onNext: { [weak self] in
//             guard let self = self else { return }
//             self.profileButton.isSelected = !self.profileButton.isSelected
//
//             if self.profileButton.isSelected {
//                 self.showEditSheet(in: self.view, type: .profile)
//                 self.editSheetView.delegate = self
//             } else {
//                 self.hideEditSheet()
//             }
//         }).disposed(by: disposeBag)
//
//         Utility.PreferenceManager.$userInfo
//             .debug("$userInfo")
//             .filter { $0 != nil }
//             .subscribe(onNext: { [weak self] model in
//                 guard let self = self, let model = model else {
//                     return
//                 }
//                 self.profileLabel.text = AES256.decrypt(encoded: model.name).correctionNickName
//                 self.profileImageView.kf.setImage(
//                     with: URL(string: WMImageAPI.fetchProfile(name: model.profile, version: model.version).toString),
//                     placeholder: nil,
//                     options: [.transition(.fade(0.2))]
//                 )
//             }).disposed(by: disposeBag)
     }

     func bindEditButtonVisable() {
         guard let vc1 = self.viewControllers[0] as? MyPlayListViewController else {
             return
         }
         guard let vc2 = self.viewControllers[1] as? FavoriteViewController else {
             return
         }

         vc1.output.dataSource
             .skip(1)
             .filter { [weak self] _ in
                 guard let self = self else { return false }
                 return (self.currentIndex ?? 0) == 0
             }
             .map { ($0.first?.items ?? []).isEmpty }
             .bind(to: editButton.rx.isHidden)
             .disposed(by: disposeBag)

         vc2.output.dataSource
             .skip(1)
             .filter { [weak self] _ in
                 guard let self = self else { return false }
                 return (self.currentIndex ?? 0) == 1
             }
             .map { ($0.first?.items ?? []).isEmpty }
             .bind(to: editButton.rx.isHidden)
             .disposed(by: disposeBag)
     }
 
     private func configureUI() {

         editButton.layer.cornerRadius = 4
         editButton.layer.borderWidth = 1
         editButton.backgroundColor = .clear
         
         editButton.layer.borderColor = DesignSystemAsset.GrayColor.gray300.color.cgColor
         
         editButton.setAttributedTitle(ButtonAttributed.edit, for: .normal)
         
         saveButton.layer.cornerRadius = 4
         saveButton.layer.borderWidth = 1
         saveButton.backgroundColor = .clear
         saveButton.layer.borderColor = Color.point.cgColor
         saveButton.setAttributedTitle(ButtonAttributed.save, for: .normal)
         saveButton.isHidden = true

         myPlayListFakeView.isHidden = true
         favoriteFakeView.isHidden = true

         // 탭바 설정
         self.dataSource = self
         let bar = TMBar.ButtonBar()

         // 배경색
         bar.backgroundView.style = .flat(color: .clear)

         // 간격 설정
         bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
         bar.layout.contentMode = .intrinsic
         bar.layout.transitionStyle = .progressive

         // 버튼 글씨 커스텀
         bar.buttons.customize { button in
             button.tintColor = DesignSystemAsset.GrayColor.gray400.color
             button.selectedTintColor = DesignSystemAsset.GrayColor.gray900.color
             button.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
             button.selectedFont = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
         }

         // indicator
         bar.indicator.weight = .custom(value: 3)
         bar.indicator.tintColor = DesignSystemAsset.PrimaryColor.point.color
         bar.indicator.overscrollBehavior = .compress
         addBar(bar, dataSource: self, at: .custom(view: tabBarView, layout: nil))
         bar.layer.addBorder(
             [.bottom],
             color: DesignSystemAsset.GrayColor.gray300.color.withAlphaComponent(0.4),
             height: 1
         )
     }
 }


extension StorageViewController: PageboyViewControllerDataSource, TMBarDataSource {
    public func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        self.viewControllers.count
    }

    public func viewController(
        for pageboyViewController: Pageboy.PageboyViewController,
        at index: Pageboy.PageboyViewController.PageIndex
    ) -> UIViewController? {
        viewControllers[index]
    }

    public func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController
        .Page? {
        nil
    }

    public func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "내 리스트")
        case 1:
            return TMBarItem(title: "좋아요")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }
}

extension StorageViewController {
    func scrollToTop() {
        let current: Int = self.currentIndex ?? 0
        guard self.viewControllers.count > current else { return }
        if let myPlayList = self.viewControllers[current] as? MyPlayListViewController {
            myPlayList.scrollToTop()
        } else if let favorite = self.viewControllers[current] as? FavoriteViewController {
            favorite.scrollToTop()
        }
    }

    public func equalHandleTapped() {
        let viewControllersCount: Int = self.navigationController?.viewControllers.count ?? 0
        if viewControllersCount > 1 {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
