//
//  Extension+UITapGesutreRecognizer.swift
//  Utility
//
//  Created by YoungK on 2023/03/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Combine
import Foundation
import UIKit

/// UIControl 을 상속받지 않는 UIView 등의 이벤트를 Combine 으로 처리하기 위한 Publisher 입니다.
public extension UITapGestureRecognizer {
    struct GesturePublisher<TapRecognizer: UITapGestureRecognizer>: Publisher {
        public typealias Output = TapRecognizer
        public typealias Failure = Never

        private let recognizer: TapRecognizer
        private let view: UIView

        init(recognizer: TapRecognizer, view: UIView) {
            self.recognizer = recognizer
            self.view = view
        }

        public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, TapRecognizer == S.Input {
            let subscription = GestureSubscription(
                subscriber: subscriber,
                recognizer: recognizer,
                view: view
            )
            subscriber.receive(subscription: subscription)
        }
    }

    final class GestureSubscription<S: Subscriber, TapRecognizer: UITapGestureRecognizer>: Subscription
        where S.Input == TapRecognizer {
        private var subscriber: S?
        private let recognizer: TapRecognizer

        init(subscriber: S, recognizer: TapRecognizer, view: UIView) {
            self.subscriber = subscriber
            self.recognizer = recognizer
            recognizer.addTarget(self, action: #selector(eventHandler))
            view.addGestureRecognizer(recognizer)
        }

        public func request(_ demand: Subscribers.Demand) {}

        public func cancel() {
            subscriber = nil
        }

        @objc func eventHandler() {
            _ = subscriber?.receive(recognizer)
        }
    }
}
