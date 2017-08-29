// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func += (lhs: inout CGPoint, rhs: CGPoint) {
  lhs = lhs + rhs
}

func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

func -= (lhs: inout CGPoint, rhs: CGPoint) {
  lhs = lhs - rhs
}

func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
  return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
}

func /= (lhs: inout CGPoint, rhs: CGFloat) {
  lhs = lhs / rhs
}
