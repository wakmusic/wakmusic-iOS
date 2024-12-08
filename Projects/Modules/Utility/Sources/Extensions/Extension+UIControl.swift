//
//  Extension+UIControl.swift
//  Utility
//
//  Created by YoungK on 2023/02/28.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Combine
import Foundation
import UIKit

@MainActor
extension UIControl {
    func controlPublisher(for event: UIControl.Event) -> UIControl.EventPublisher {
        return UIControl.EventPublisher(control: self, event: event)
    }

    /// Publisher
    @MainActor
    struct EventPublisher: @preconcurrency Publisher {
        typealias Output = UIControl
        typealias Failure = Never

        let control: UIControl
        let event: UIControl.Event

        func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, UIControl == S.Input {
            let subscription = EventSubscription(control: control, subscrier: subscriber, event: event)
            subscriber.receive(subscription: subscription)
        }
    }

    /// Subscription
    @MainActor
    fileprivate class EventSubscription<EventSubscriber: Subscriber>: Subscription, Sendable
        where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {
        let control: UIControl
        let event: UIControl.Event
        var subscriber: EventSubscriber?

        init(control: UIControl, subscrier: EventSubscriber, event: UIControl.Event) {
            self.control = control
            self.subscriber = subscrier
            self.event = event

            control.addTarget(self, action: #selector(eventDidOccur), for: event)
        }

        nonisolated func request(_ demand: Subscribers.Demand) {}

        nonisolated func cancel() {
            if Thread.isMainThread {
                MainActor.assumeIsolated {
                    subscriber = nil
                    control.removeTarget(self, action: #selector(eventDidOccur), for: event)
                }
            } else {
                Task { @MainActor in
                    subscriber = nil
                    control.removeTarget(self, action: #selector(eventDidOccur), for: event)
                }
            }
        }

        @objc func eventDidOccur() {
            _ = subscriber?.receive(control)
        }
    }
}
