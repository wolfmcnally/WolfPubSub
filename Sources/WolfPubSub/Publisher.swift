//
//  Publisher.swift
//  WolfPubSub
//
//  Created by Wolf McNally on 5/29/17.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import WolfCore

public protocol PublisherProtocol: Hashable {
    associatedtype PublishableType: Publishable
    associatedtype SubscriberType

    func publish(_ item: PublishableType)
    func unpublish(_ item: PublishableType)
}

public class Publisher<T: Publishable>: PublisherProtocol {
    public typealias `Self` = Publisher<T>
    public typealias PublishableType = T
    public typealias SubscriberType = Subscriber<PublishableType>

    private let id = UUID()
    private var publishedItems = Set<PublishableType>()
    private var subscribers = WeakSet<SubscriberType>()

    public init() {
    }

    public func publish(_ item: PublishableType) {
        guard case (true, _) = publishedItems.insert(item) else { return }
        for subscriber in subscribers {
            subscriber.addPublishable(item)
        }
        guard let duration = item.duration else { return }
        dispatchOnMain(afterDelay: duration) { [weak self] in
            self?.unpublish(item)
        }
    }

    public func unpublish(_ item: PublishableType) {
        guard publishedItems.remove(item) != nil else { return }
        for subscriber in subscribers {
            subscriber.removePublishable(item)
        }
    }

    func addSubscriber(_ subscriber: SubscriberType) {
        guard case (true, _) = subscribers.insert(subscriber) else { return }
        for item in publishedItems {
            subscriber.addPublishable(item)
        }
    }

    func removeSubscriber(_ subscriber: SubscriberType) {
        guard subscribers.remove(subscriber) != nil else { return }
        for item in publishedItems {
            subscriber.removePublishable(item)
        }
    }

    private func removeAllSubscribers() {
        for subscriber in subscribers {
            removeSubscriber(subscriber)
        }
    }

    deinit {
        removeAllSubscribers()
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
