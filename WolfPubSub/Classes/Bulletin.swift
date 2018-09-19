//
//  Bulletin.swift
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

public typealias BulletinPublisher = Publisher<Bulletin>
public typealias BulletinSubscriber = Subscriber<Bulletin>

open class Bulletin: Publishable {
    private typealias `Self` = Bulletin

    private static var _nextID: Int = 1

    public static let minimumPriority = 0
    public static let normalPriority = 500
    public static let maximumPriority = 1000

    private static func nextID() -> Int {
        defer { _nextID += 1 }
        return _nextID
    }

    public let id: Int
    public let date: Date
    public let priority: Int
    public let duration: TimeInterval?

    public init(priority: Int = normalPriority, duration: TimeInterval? = nil) {
        self.id = Self.nextID()
        self.date = Date()
        self.priority = priority
        self.duration = duration
    }

    public var hashValue: Int {
        return id
    }

    public static func == (lhs: Bulletin, rhs: Bulletin) -> Bool {
        return lhs.id == rhs.id
    }
}
