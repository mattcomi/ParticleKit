// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

/// The components that make up a `UIColor` in the RGB color space.
public struct ColorRGBA {
  public var red: CGFloat
  public var green: CGFloat
  public var blue: CGFloat
  public var alpha: CGFloat

  /// Creates a ColorRGBA from a UIColor.
  public init(_ color: UIColor) {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0

    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
  }
}

extension UIColor : Interpolatable {
  public static func interpolate(lhs: UIColor, rhs: UIColor, factor: CGFloat) -> Self {
    let lhsRGBA = ColorRGBA(lhs)
    let rhsRGBA = ColorRGBA(rhs)

    let red = lerp(min: lhsRGBA.red, max: rhsRGBA.red, factor: factor)
    let green = lerp(min: lhsRGBA.green, max: rhsRGBA.green, factor: factor)
    let blue = lerp(min: lhsRGBA.blue, max: rhsRGBA.blue, factor: factor)
    let alpha = lerp(min: lhsRGBA.alpha, max: rhsRGBA.alpha, factor: factor)

    return self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
