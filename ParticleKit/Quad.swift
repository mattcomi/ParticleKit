// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

private let numberOfPoints = 4

/// A closed Quad shape.
public struct Quad {
  private var points = [CGPoint]()

  /// Creates a Quad with points of `(0, 0)`.
  public init() {
    points.reserveCapacity(numberOfPoints)

    for _ in 0..<numberOfPoints {
      points.append(.zero)
    }
  }

  /// Creates a Quad with a rect.
  public init(rect: CGRect) {
    points.reserveCapacity(4)

    points.append(rect.origin)
    points.append(CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y))
    points.append(CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height))
    points.append(CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height))
  }

  /// Returns the point at the specified index.
  public func point(index: Int) -> CGPoint {
    guard index >= 0 && index < numberOfPoints else { fatalError("Unexpected index") }
    return points[index]
  }

  /// Sets the point at the specified index.
  public mutating func setPoint(index: Int, point: CGPoint) {
    guard index >= 0 && index < numberOfPoints else { fatalError("Unexpected index") }
    points[index] = point
  }

  /// Translates the Quad.
  public mutating func translate(_ translation: CGPoint) {
    for i in 0..<numberOfPoints {
      points[i] += translation
    }
  }

  /// Rotates the Quad.
  public mutating func rotate(angle: Angle) {
    guard angle != .zero else { return }

    let matrix = Matrix22(angle: angle)

    for i in 0..<numberOfPoints {
      points[i] *= matrix
    }
  }

  /// Returns whether the Quad contains the specified point.
  public func contains(point: CGPoint) -> Bool {
    // Adapted from https://stackoverflow.com/a/2922778/676411

    var result = false

    var j = numberOfPoints - 1

    for i in 0..<numberOfPoints {
      if (points[i].y > point.y) != (points[j].y > point.y) &&
        (point.x < (points[j].x - points[i].x) * (point.y - points[i].y) / (points[j].y - points[i].y) + points[i].x) {

        result = !result
      }

      j = i
    }

    return result
  }
}
