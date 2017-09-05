// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

public class Particle {
  public internal(set) var position: CGPoint
  public internal(set) var linearVelocity: CGPoint
  public internal(set) var angle: Angle
  public internal(set) var angularVelocity: Angle
  public internal(set) var lifetime: Int
  public internal(set) var remainingLifetime: Int
  public internal(set) weak var prev: Particle?
  public internal(set) weak var next: Particle?
  public internal(set) var quad = Quad(rect: .zero)
  public internal(set) var color = UIColor.white

  convenience init() {
    self.init(
      position: .zero,
      linearVelocity: .zero,
      angle: .zero,
      angularVelocity: .zero,
      lifetime: 0,
      prev: nil,
      next: nil)
  }

  init(
    position: CGPoint,
    linearVelocity: CGPoint,
    angle: Angle,
    angularVelocity: Angle,
    lifetime: Int,
    prev: Particle?,
    next: Particle?) {

    self.position = position
    self.linearVelocity = linearVelocity
    self.angle = angle
    self.angularVelocity = angularVelocity
    self.lifetime = lifetime
    self.remainingLifetime = lifetime
    self.prev = prev
    self.next = next    
  }

  func reset() {
    position = .zero
    linearVelocity = .zero
    angle = .zero
    angularVelocity = .zero
    lifetime = 0
    prev = nil
    next = nil
  }
}
