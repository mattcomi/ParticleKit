// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

/// An object that may be managed by a `ReusePool`.
public protocol ReusePoolElement: class {
  init()

  /// An item managed by the `ReusePool` in which this element is contained.
  var reusePoolItem: ReusePoolItem? { get set }

  /// Prepares the `ReusePoolElement` for reuse. This method is invoked prior to the `ReusePoolElement` being dequeued.
  func prepareForReuse()
}

public class ReusePoolItem {
  internal init(reusePool: ReusePoolProtocol, element: ReusePoolElement) {
    self.reusePool = reusePool
    self.element = element
  }

  internal var isAvailable: Bool = true

  internal unowned var reusePool: ReusePoolProtocol
  internal unowned var element: ReusePoolElement
  internal weak var previous: ReusePoolItem?
  internal weak var next: ReusePoolItem?
}

public class ReusePoolIterator<T: ReusePoolElement>: IteratorProtocol {
  private var reusePoolElement: ReusePoolElement?

  internal init(firstReusePoolElement: ReusePoolElement?) {
    self.reusePoolElement = firstReusePoolElement
  }

  public func next() -> T? {
    if let reusePoolElement = self.reusePoolElement {
      self.reusePoolElement = reusePoolElement.reusePoolItem!.next?.element

      return reusePoolElement as? T
    }

    return nil
  }
}

public class ReusePoolSequence<T: ReusePoolElement>: Sequence {
  public typealias Iterator = ReusePoolIterator<T>

  private var reusePoolElement: ReusePoolElement?

  internal init(firstReusePoolElement: ReusePoolElement?) {
    reusePoolElement = firstReusePoolElement
  }

  public func makeIterator() -> ReusePoolSequence.Iterator {
    return ReusePoolIterator(firstReusePoolElement: reusePoolElement)
  }
}

internal protocol ReusePoolProtocol: class {}

public class ReusePool<T: ReusePoolElement>: ReusePoolProtocol {
  private var reusePool = [ReusePoolElement]()

  private var firstAvailableElement: ReusePoolElement?
  private var firstUnavailableElement: ReusePoolElement?
  private var lastUnavailableElement: ReusePoolElement?

  /// Creates a `ReusePool` with the specified `size`.
  /// - parameter size: The number of elements that this `ReusePool` should manage.
  public init(size: Int) {
    for i in 0..<size {
      let reusePoolElement = T()

      reusePoolElement.reusePoolItem = ReusePoolItem(reusePool: self, element: reusePoolElement)

      if i > 0 {
        reusePoolElement.reusePoolItem!.previous = reusePool[i - 1].reusePoolItem!
        reusePool[i - 1].reusePoolItem!.next = reusePoolElement.reusePoolItem!
      }

      reusePool.append(reusePoolElement)
    }

    firstAvailableElement = reusePool[0]
  }

  /// The available elements.
  public var availableElements: ReusePoolSequence<T> {
    return ReusePoolSequence(firstReusePoolElement: firstAvailableElement)
  }

  /// The unavailable elements.
  public var unavailableElements: ReusePoolSequence<T> {
    return ReusePoolSequence(firstReusePoolElement: firstUnavailableElement)
  }

  /// Dequeues the first available element if one exists.
  public func dequeueFirstAvailable() -> T? {
    guard let reusePoolElement = firstAvailableElement else { return nil }

    guard reusePoolElement.reusePoolItem!.reusePool === self else { fatalError("Unexpected reusePool") }
    guard reusePoolElement.reusePoolItem!.isAvailable else { fatalError("Expected isAvailable") }

    firstAvailableElement = reusePoolElement.reusePoolItem!.next?.element

    if firstUnavailableElement == nil {
      firstUnavailableElement = reusePoolElement
    }

    reusePoolElement.reusePoolItem!.previous = lastUnavailableElement?.reusePoolItem!
    reusePoolElement.reusePoolItem!.next = nil

    lastUnavailableElement?.reusePoolItem!.next = reusePoolElement.reusePoolItem!

    lastUnavailableElement = reusePoolElement

    reusePoolElement.reusePoolItem!.isAvailable = false
    reusePoolElement.reusePoolItem!.element.prepareForReuse()

    return reusePoolElement as? T
  }

  /// Dequeues the first unavailable elements if one exists. This is the element that was least recently enqueued.
  public func dequeueFirstUnavailable() -> T? {
    if let firstUnavailableElement = self.firstUnavailableElement {
      enqueue(firstUnavailableElement as! T)
      return dequeueFirstAvailable()
    } else {
      return nil
    }
  }

  /// Enqueues an element that was previously dequeued. It is a fatal error to enqueue an element that:
  /// - Is not managed by this `ReusePool`.
  /// - Has already been enqueued.
  ///
  /// - parameter reusePoolElement - The element to enqueue.
  public func enqueue(_ reusePoolElement: T) {
    guard let reusePoolItem = reusePoolElement.reusePoolItem else { fatalError("Expected reusePoolItem") }

    guard reusePoolItem.reusePool === self else { fatalError("Unexpected reusePool") }
    guard !reusePoolItem.isAvailable else { fatalError("Expected !isAvailable") }

    if firstUnavailableElement === reusePoolElement {
      firstUnavailableElement = firstUnavailableElement!.reusePoolItem!.next?.element
    }

    if lastUnavailableElement === reusePoolElement {
      lastUnavailableElement = nil
    }

    firstAvailableElement?.reusePoolItem!.previous = reusePoolElement.reusePoolItem!
    reusePoolElement.reusePoolItem!.next = firstAvailableElement?.reusePoolItem!
    reusePoolElement.reusePoolItem!.isAvailable = true

    firstAvailableElement = reusePoolElement
  }
}
