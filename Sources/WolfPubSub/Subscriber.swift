//
//  Subscriber.swift
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

public protocol SubscriberProtocol: Hashable {
    associatedtype PublishableType
    associatedtype PublisherType

    func subscribe(to publisher: PublisherType)
    func unsubscribe(from publisher: PublisherType)
}

public class Subscriber<T: Publishable>: SubscriberProtocol {
    public typealias `Self` = Subscriber<T>
    public typealias PublishableType = T
    public typealias PublisherType = Publisher<PublishableType>

    private let id = UUID()
    private var subscribedItems = Set<PublishableType>()
    private var publishers = WeakSet<PublisherType>()

    public typealias ItemBlock = (PublishableType) -> Void
    public var onAddedItem: ItemBlock?
    public var onRemovedItem: ItemBlock?

    public init() {
    }

    func addPublishable(_ item: PublishableType) {
        guard case (true, _) = subscribedItems.insert(item) else { return }
        onAddedItem?(item)
    }

    func removePublishable(_ item: PublishableType) {
        guard subscribedItems.remove(item) != nil else { return }
        onRemovedItem?(item)
    }

    public func subscribe(to publisher: PublisherType) {
        guard case (true, _) = publishers.insert(publisher) else { return }
        publisher.addSubscriber(self)
    }

    public func unsubscribe(from publisher: PublisherType) {
        guard publishers.remove(publisher) != nil else { return }
        publisher.removeSubscriber(self)
    }

    private func removeAllPublishers() {
        for publisher in publishers {
            unsubscribe(from: publisher)
        }
    }

    deinit {
        removeAllPublishers()
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
