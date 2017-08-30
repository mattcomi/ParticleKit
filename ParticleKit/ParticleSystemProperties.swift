// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

protocol ParticleSystemValueType {
  associatedtype ValueType

  var origin: ValueType { get }
  var spread: ValueType { get }
}

public struct ParticleSystemValue<T>: ParticleSystemValueType {
  typealias ValueType = T

  public init(origin: T, spread: T) {
    self.origin = origin
    self.spread = spread
  }

  public var origin: T
  public var spread: T
}

extension ParticleSystemValueType where ValueType == Int {
  var randomValue: Int {
    let value = CGFloat(origin) + random(location: CGFloat(spread) / -2.0, length: CGFloat(spread))

    return ValueType(value)
  }
}

extension ParticleSystemValueType where ValueType == CGFloat {
  var randomValue: CGFloat {
    return origin + random(location: spread / -2.0, length: spread)
  }
}

extension ParticleSystemValueType where ValueType == CGPoint {
  var randomValue: CGPoint {
    return origin + random(location: spread / -2.0, length: spread)
  }
}

extension ParticleSystemValueType where ValueType == Angle {
  var randomValue: Angle {
    return origin + Angle(radians: random(location: spread.radians / -2.0, length: spread.radians))
  }
}

/// The properties of emitted particles.
public struct ParticleSystemProperties {
  public init() { }

  /// The position at which particles should be emitted.
  public var position: ParticleSystemValue<CGPoint> = ParticleSystemValue(origin: .zero, spread: .zero)

  /// The lifetime (in updates) of emitted particles. The default value is `ParticleSystemValue(origin: 60, spread: 0)`
  public var lifetime: ParticleSystemValue<Int> = ParticleSystemValue(origin: 60, spread: 0)

  /// The angle at which particles should be emitted.
  public var linearVelocityAngle: ParticleSystemValue<Angle> = ParticleSystemValue(origin: .zero, spread: .zero)

  /// The speed (in units per update) at which particles should be emitted.
  public var linearVelocitySpeed: ParticleSystemValue<CGFloat> = ParticleSystemValue(origin: 0, spread: 0)

  /// The initial angle of particles.
  public var angle: ParticleSystemValue<Angle> = ParticleSystemValue(origin: .zero, spread: .zero)

  /// The angular velocity (in angle per update) of emitted particles.
  public var angularVelocity: ParticleSystemValue<Angle> = ParticleSystemValue(origin: .zero, spread: .zero)
}
