// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

public typealias ColorGradient = Gradient<UIColor>

struct GradientItem<T:Interpolatable> {
  var location: CGFloat
  var value: T
}

/// A gradient of locations (typically between 0 and 1) of any `Interpolatable` type.
public class Gradient<T:Interpolatable> {
  private var items = [GradientItem<T>]()

  /// Creates a gradient using the specified values at locations 0 and 1.
  public convenience init(first: T, last: T) {
    self.init()

    add(location: 0, value: first)
    add(location: 1, value: last)
  }

  /// Creates an empty gradient.
  public init() {}

  /// Adds a value at the specified location, replacing an existing value if necessary.
  /// - parameter location: The location of the value.
  /// - parameter value: The value.
  public func add(location: CGFloat, value: T) {
    if let indexOfExistingItem = items.index(where: { $0.location == location }) {
      items[indexOfExistingItem].value = value
    } else {
      items.append(GradientItem(location: location, value: value))
      items.sort { return $0.location < $1.location }
    }
  }

  /// Removes all values.
  public func removeAllValues() {
    items.removeAll()
  }

  /// Returns the value at the specified location. Asserts that there is at least one value.
  public func value(at location: CGFloat) -> T {
    guard items.count != 0 else { fatalError("Unexpected items.count") }

    let first = items.first!
    let last = items.last!

    if first.location > location { return first.value }
    if last.location < location { return last.value }

    // find the index of the first item after the specified location.
    guard let nextIndex = items.index(where: { return $0.location > location }) else {
      fatalError("Expected index")
    }

    let next = items[nextIndex]
    let prev: GradientItem<T>!

    if nextIndex == 0 {
      prev = next
    } else {
      prev = items[nextIndex - 1]
    }

    let factor = CGFloat(location - prev.location) / CGFloat(next.location - prev.location)

    return T.interpolate(lhs: prev.value, rhs: next.value, factor: factor)
  }
}
