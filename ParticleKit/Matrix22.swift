// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

/// A 2x2 matrix.
public struct Matrix22 {
  public private(set) var columns = [CGPoint]()

  /// The identity matrix.
  public static var identity = Matrix22(x0: 1, y0: 0, x1: 0, y1: 1)

  /// Creates a matrix from an angle.
  public init(angle: Angle) {
    let radians = angle.radians

    let cosine = cos(radians)
    let sine = sin(radians)

    self.init(x0: cosine, y0: sine, x1: -sine, y1: cosine)
  }

  public init(x0: CGFloat, y0: CGFloat, x1: CGFloat, y1: CGFloat) {
    columns.reserveCapacity(2)

    columns.append(CGPoint(x: x0, y: y0))
    columns.append(CGPoint(x: x1, y: y1))
  }
}

public func * (vector: CGPoint, matrix: Matrix22) -> CGPoint {
  return CGPoint(
    x: matrix.columns[0].x * vector.x + matrix.columns[1].x * vector.y,
    y: matrix.columns[0].y * vector.x + matrix.columns[1].y * vector.y)
}

public func *= (vector: inout CGPoint, matrix: Matrix22) {
  vector = vector * matrix
}
