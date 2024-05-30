import BaseFeature
import DesignSystem
import Foundation
import LogManager
import MyInfoFeatureInterface
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

final class MyInfoViewController: BaseReactorViewController<MyInfoReactor> {
    let loginWarningView = LoginWarningView(text: "로그인을 해주세요.")

    override func configureNavigation() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func addView() {
        self.view.addSubview(loginWarningView)
    }

    override func setLayout() {
        self.view.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color

        loginWarningView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    override func bindState(reactor: MyInfoReactor) {}

    override func bindAction(reactor: MyInfoReactor) {
        loginWarningView.rx.loginButtonDidTap.subscribe { _ in
            print("로그인 버튼 눌림")
        }.disposed(by: disposeBag)
    }
}
