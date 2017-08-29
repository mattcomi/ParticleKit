// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

public class Particle {
  public internal(set) var position: CGPoint
  public internal(set) var linearVelocity: CGPoint
  public internal(set) var angle: Angle
  public internal(set) var angularVelocity: Angle
  public internal(set) var lifetime: Int
  public internal(set) var remainingLifetime: Int
  public internal(set) var prevParticle: Particle?
  public internal(set) var nextParticle: Particle?
  public internal(set) var quad = Quad(rect: .zero)
  public internal(set) var color = UIColor.white

  convenience init() {
    self.init(
      position: .zero,
      linearVelocity: .zero,
      angle: .zero,
      angularVelocity: .zero,
      lifetime: 0,
      nextParticle: nil,
      prevParticle: nil)
  }

  init(
    position: CGPoint,
    linearVelocity: CGPoint,
    angle: Angle,
    angularVelocity: Angle,
    lifetime: Int,
    nextParticle: Particle?,
    prevParticle: Particle?) {

    self.position = position
    self.linearVelocity = linearVelocity
    self.angle = angle
    self.angularVelocity = angularVelocity
    self.lifetime = lifetime
    self.remainingLifetime = lifetime
    self.nextParticle = nextParticle
    self.prevParticle = prevParticle
  }
}
