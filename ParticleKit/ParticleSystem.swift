// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

public class ParticleSystemIterator: IteratorProtocol {
  var particle: Particle?

  init(_ particle: Particle?) {
    self.particle = particle
  }
 
  public func next() -> Particle? {
    if let particle = self.particle {
      self.particle = particle.nextParticle
      return particle
    }

    return nil
  }
}

public class ParticleSystem: Sequence {
  private var pool = [Particle]()
  private var nextAvailableParticleIndex = 0
  private var firstParticle: Particle?
  private var lastParticle: Particle?

  public var properties = ParticleSystemProperties()
  public var colorGradient: Gradient<UIColor> = Gradient(first: UIColor.red, last: UIColor.yellow)
  public var sizeGradient: Gradient<CGFloat> = Gradient(first: 1, last: 1)

  /// Creates and returns a particle system.
  /// - parameter capacity: The number of particles that may exist at any given time. If a particle is emitted beyond 
  ///                       this capacity, an existing particle will be replaced.
  public init(capacity: Int) {
    for _ in 0..<capacity {
      pool.append(Particle())
    }

    nextAvailableParticleIndex = 0
  }

  /// Emits a particle.
  public func emit() {
    let particle = nextAvailableParticle()

    particle.position = properties.position.randomValue

    let linearVelocityAngle = properties.linearVelocityAngle.randomValue
    let linearVelocitySpeed = properties.linearVelocitySpeed.randomValue

    particle.linearVelocity = CGPoint(
      x: cos(linearVelocityAngle.radians) * linearVelocitySpeed,
      y: sin(linearVelocityAngle.radians) * linearVelocitySpeed)

    particle.angle = properties.angle.randomValue
    particle.angularVelocity = properties.angularVelocity.randomValue

    let lifetime = properties.lifetime.randomValue

    particle.lifetime = lifetime
    particle.remainingLifetime = lifetime

    if firstParticle == nil {
      firstParticle = particle
      lastParticle = particle
    } else {
      lastParticle!.nextParticle = particle

      particle.prevParticle = lastParticle!
      particle.nextParticle = nil

      lastParticle = particle
    }
  }

  /// Updates the particle system.
  public func update() {
    var particle = firstParticle

    while particle != nil {
      if particle?.remainingLifetime == 0 {
        // unlink this particle
        if particle?.prevParticle != nil {
          particle?.prevParticle?.nextParticle = particle?.nextParticle
        }

        if particle === firstParticle {
          firstParticle = particle?.nextParticle
        }
      } else {
        let life = 1 - (CGFloat(particle!.remainingLifetime) / CGFloat(particle!.lifetime))

        let size = sizeGradient.value(at: life)

        particle!.color = colorGradient.value(at: life)

        var quad = Quad(rect: CGRect(x: size / -2.0, y: size / -2.0, width: size, height: size))

        quad.rotate(angle: particle!.angle)
        quad.translate(particle!.position)

        particle?.quad = quad

        particle?.position = particle!.position + particle!.linearVelocity
        particle?.angle = Angle(radians: particle!.angle.radians + particle!.angularVelocity.radians)
      }

      particle?.remainingLifetime -= 1

      particle = particle?.nextParticle
    }
  }

  /// Removes all particles.
  public func removeAllParticles() {
    for i in 0..<pool.count {
      pool[i] = Particle()
    }

    nextAvailableParticleIndex = 0
  }

  public func makeIterator() -> ParticleSystemIterator {
    return ParticleSystemIterator(firstParticle)
  }

  private func nextAvailableParticle() -> Particle {
    let particle = pool[nextAvailableParticleIndex]

    nextAvailableParticleIndex += 1

    if nextAvailableParticleIndex == pool.count {
      nextAvailableParticleIndex = 0
    }

    return particle
  }
}
