// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

/// A 2D particle system.
public class ParticleSystem {
  private var unusedParticleItems = LinkedList<Particle>()
  private var particleItems = LinkedList<Particle>()

  public var properties = ParticleSystemProperties()
  public var colorGradient: Gradient<UIColor> = Gradient(first: UIColor.red, last: UIColor.yellow)
  public var sizeGradient: Gradient<CGFloat> = Gradient(first: 1, last: 1)

  /// Creates and returns a particle system.
  /// - parameter capacity: The number of particles that may exist at any given time. If a particle is emitted beyond 
  ///   this capacity, the oldest existing particle will be replaced.
  public init(capacity: Int) {
    for _ in 0..<capacity {
      unusedParticleItems.append(value: Particle())
    }
  }

  /// The particles.
  public var particles: LinkedListItemValueSequence<Particle> {
    return LinkedListItemValueSequence(linkedList: particleItems)
  }

  /// Emits a particle.
  public func emit() {
    let particle = nextAvailableParticle()

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

    particleItems.append(value: particle)
  }

  /// Updates the particle system.
  public func update() {
    for item in particleItems.items {
      let particle = item.value

      if particle.remainingLifetime == 0 {
        item.removeFromLinkedList()
        unusedParticleItems.append(value: particle)
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
    for item in particleItems.items {
      item.value.reset()
      item.removeFromLinkedList()

      unusedParticleItems.append(value: item.value)
    }
  }

  private func nextAvailableParticle() -> Particle {
    let item: LinkedListItem<Particle>

    if let unusedParticleItem = unusedParticleItems.last {
      item = unusedParticleItem
    } else {
      item = particleItems.first!
      item.value.reset()
    }

    item.removeFromLinkedList()

    return item.value
  }
}
