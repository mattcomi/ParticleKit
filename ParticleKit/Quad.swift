// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

public struct Quad {
  private static var numberOfPoints = 4

  private var points = [CGPoint]()

  /// Creates a Quad with a rect.
  public init(rect: CGRect) {
    points.append(rect.origin)
    points.append(CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y))
    points.append(CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height))
    points.append(CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height))
  }

  /// Returns the point at the specified index.
  public func point(index: Int) -> CGPoint {
    guard index >= 0 && index < Quad.numberOfPoints else { fatalError("Unexpected index") }
    return points[index]
  }

  /// Sets the point at the specified index.
  mutating func setPoint(index: Int, point: CGPoint) {
    guard index >= 0 && index < Quad.numberOfPoints else { fatalError("Unexpected index") }
    points[index] = point
  }

  /// Translates the Quad.
  public mutating func translate(_ translation: CGPoint) {
    for i in 0..<Quad.numberOfPoints {
      points[i].x += translation.x
      points[i].y += translation.y
    }
  }

  /// Rotates the Quad.
  mutating func rotate(angle: Angle) {
    let matrix = Matrix22(angle: angle)

    for i in 0..<Quad.numberOfPoints {
      points[i] *= matrix
    }
  }
}
