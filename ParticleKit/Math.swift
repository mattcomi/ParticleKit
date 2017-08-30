// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

/// A type that can be interpolated.
public protocol Interpolatable {
  static func interpolate(lhs: Self, rhs: Self, factor: CGFloat) -> Self
}

extension CGFloat : Interpolatable {
  public static func interpolate(lhs: CGFloat, rhs: CGFloat, factor: CGFloat) -> CGFloat {
    return lerp(min: lhs, max: rhs, factor: factor)
  }
}

/// Linearly interpolates between two values.
public func lerp<T: FloatingPoint>(min: T, max: T, factor: T) -> T {
  return (1 - factor) * min + factor * max
}

public func random<T: FloatingPoint>(location: T, length: T) -> T {
  guard length != 0 else { return location }

  let randomNumber = T(arc4random()) / T(UINT32_MAX)

  return (randomNumber * length) + location
}

public func random(location: CGPoint, length: CGPoint) -> CGPoint {
  let x = random(location: -location.x, length: length.x)
  let y = random(location: -location.y, length: length.y)

  return CGPoint(x: x, y: y)
}

public func random(location: Angle, length: Angle) -> Angle {
  return Angle(radians: random(location: location.radians, length: length.radians))
}
