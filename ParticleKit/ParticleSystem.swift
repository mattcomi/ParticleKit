// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

/// A 2D particle system.
public class ParticleSystem {
  private var pool: ReusePool<Particle>

  public var properties = ParticleSystemProperties()
  public var colorGradient: Gradient<UIColor> = Gradient(first: UIColor.red, last: UIColor.yellow)
  public var sizeGradient: Gradient<CGFloat> = Gradient(first: 1, last: 1)

  /// Creates and returns a particle system.
  /// - parameter size: The number of particles that may exist at any given time. If a particle is emitted beyond
  ///   this size, the oldest existing particle will be replaced.
  public init(size: Int) {
    pool = ReusePool(size: size)
  }

  /// The particles.
  public var particles: ReusePoolSequence<Particle> {
    return pool.unavailableElements
  }

  /// Emits a particle.
  public func emit() {
    guard let particle = dequeueParticle() else { fatalError() }

    particle.position = properties.position.random

    let linearVelocityAngle = properties.linearVelocityAngle.random
    let linearVelocitySpeed = properties.linearVelocitySpeed.random

    particle.linearVelocity = CGPoint(
      x: cos(linearVelocityAngle.radians) * linearVelocitySpeed,
      y: sin(linearVelocityAngle.radians) * linearVelocitySpeed)

    particle.angle = properties.angle.random
    particle.angularVelocity = properties.angularVelocity.random

    let lifetime = properties.lifetime.random

    particle.lifetime = lifetime
    particle.remainingLifetime = lifetime
  }

  /// Updates the particle system.
  public func update() {
    for particle in pool.unavailableElements {
      if particle.remainingLifetime == 0 {
        pool.enqueue(particle)
      } else {
        let life = 1 - (CGFloat(particle.remainingLifetime) / CGFloat(particle.lifetime))

        let size = sizeGradient.value(at: life)

        particle.color = colorGradient.value(at: life)

        var quad = Quad(rect: CGRect(x: size / -2.0, y: size / -2.0, width: size, height: size))

        quad.rotate(angle: particle.angle)
        quad.translate(particle.position)

        particle.quad = quad

        particle.position = particle.position + particle.linearVelocity
        particle.angle = Angle(radians: particle.angle.radians + particle.angularVelocity.radians)

        particle.remainingLifetime -= 1
      }
    }
  }

  /// Removes all particles.
  public func removeAll() {
    for item in pool.unavailableElements {
      pool.enqueue(item)
    }
  }

  private func dequeueParticle() -> Particle? {
    if let particle = pool.dequeueFirstAvailable() {
      return particle
    }

    if let particle = pool.dequeueFirstUnavailable() {
      return particle
    }

    return nil
  }
}
