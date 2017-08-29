// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

public struct Angle {
  /// A zero angle.
  public static let zero = Angle(radians: 0)

  /// The angle is radians.
  public let radians: CGFloat

  /// Creates an angle in degrees.
  public init(degrees: CGFloat) {
    self.radians = degrees * (.pi / 180)
  }

  /// Creates an angle in radians.
  public init(radians: CGFloat) {
    self.radians = radians
  }

  /// The angle in degrees.
  public var degrees: CGFloat {
    return radians * (180 / .pi)
  }
}

public func + (lhs: Angle, rhs: Angle) -> Angle {
  return Angle(radians: lhs.radians + rhs.radians)
}

public func += (lhs: inout Angle, rhs: Angle) {
  lhs = lhs + rhs
}
