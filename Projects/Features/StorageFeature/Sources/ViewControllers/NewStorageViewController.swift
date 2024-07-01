import BaseFeature
import DesignSystem
import Pageboy
import ReactorKit
import RxSwift
import SignInFeatureInterface
import Tabman
import UIKit
import Utility

final class NewStorageViewController: TabmanViewController, View {
    typealias Reactor = StorageReactor
    var disposeBag = DisposeBag()
    let storageView = StorageView()

    override func loadView() {
        view = storageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        storageView.rx.createListButtonDidTap.subscribe { _ in
            print("🚀 리스트 생성 버튼 눌림")
        }.disposed(by: disposeBag)

        storageView.rx.editButtonDidTap.subscribe { _ in
            print("🚀 편집 버튼 눌림")
        }.disposed(by: disposeBag)

        storageView.rx.saveButtonDidTap.subscribe { _ in
            print("🚀 저장 버튼 눌림")
        }.disposed(by: disposeBag)

        storageView.rx.drawFruitButtonDidTap.subscribe { _ in
            print("🚀 열매 뽑기 버튼 눌림")
        }.disposed(by: disposeBag)

        storageView.rx.loginButtonDidTap.subscribe { _ in
            print("🚀 로그인 버튼 눌림")
        }.disposed(by: disposeBag)
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
        // self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func viewController() -> UIViewController {
        return NewStorageViewController()
    }
}

extension NewStorageViewController {
    func bind(reactor: Reactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }

    func bindState(reactor: Reactor) {}

    func bindAction(reactor: Reactor) {}
}

extension NewStorageViewController: EqualHandleTappedType {
    func equalHandleTapped() {}
}
