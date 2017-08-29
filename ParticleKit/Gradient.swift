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

  /// Adds a value at the specified location.
  public func add(location: CGFloat, value: T) {
    items.append(GradientItem(location: location, value: value))
    items.sort { return $0.location < $1.location }
  }

  /// Returns the item at the specified location.
  public func item(at location: CGFloat) -> T {
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
