// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

public class LinkedListItem<T: AnyObject> {
  public private(set) var value: T

  public fileprivate(set) var next: LinkedListItem?
  public fileprivate(set) weak var previous: LinkedListItem?
  public fileprivate(set) unowned var linkedList: LinkedList<T>

  fileprivate init(_ value: T, linkedList: LinkedList<T>) {
    self.value = value
    self.linkedList = linkedList
  }

  public func removeFromLinkedList() {
    if let previous = previous {
      previous.next = next
    } else {
      linkedList.first = next
    }

    next?.previous = previous

    if next == nil {
      linkedList.last = previous
    }

    previous = nil
    next = nil
  }
}

public class LinkedListItemIterator<T: AnyObject>: IteratorProtocol {
  var item: LinkedListItem<T>?

  init(linkedList: LinkedList<T>) { self.item = linkedList.first }

  public func next() -> LinkedListItem<T>? {
    if let item = self.item {
      self.item = item.next
      return item
    }

    return nil
  }
}

public class LinkedListItemValueIterator<T: AnyObject>: IteratorProtocol {
  var item: LinkedListItem<T>?

  init(linkedList: LinkedList<T>) { self.item = linkedList.first }

  public func next() -> T? {
    if let item = self.item {
      self.item = item.next
      return item.value
    }

    return nil
  }
}

public struct LinkedListItemSequence<T: AnyObject>: Sequence {
  public typealias Iterator = LinkedListItemIterator<T>

  private let linkedList: LinkedList<T>

  public init(linkedList: LinkedList<T>) { self.linkedList = linkedList }

  public func makeIterator() -> LinkedListItemSequence<T>.Iterator {
    return LinkedListItemIterator(linkedList: linkedList)
  }
}

public struct LinkedListItemValueSequence<T: AnyObject>: Sequence {
  public typealias Iterator = LinkedListItemValueIterator<T>

  private let linkedList: LinkedList<T>

  public init(linkedList: LinkedList<T>) { self.linkedList = linkedList }

  public func makeIterator() -> LinkedListItemValueSequence<T>.Iterator {
    return LinkedListItemValueIterator(linkedList: linkedList)
  }
}

/// A doubly linked list.
public class LinkedList<T: AnyObject> {
  public fileprivate(set) var first: LinkedListItem<T>?
  public fileprivate(set) var last: LinkedListItem<T>?

  public func append(value: T) {
    let item = LinkedListItem(value, linkedList: self)

    if let last = self.last {
      item.previous = last
      last.next = item
    } else {
      first = item
    }

    last = item
  }

  /// The linked list items.
  var items: LinkedListItemSequence<T> {
    return LinkedListItemSequence(linkedList: self)
  }

  /// The linked list item values.
  var values: LinkedListItemValueSequence<T> {
    return LinkedListItemValueSequence(linkedList: self)
  }
}
