// Copyright © 2017 Matt Comi. All rights reserved.

import Foundation

protocol EmitterValueType {
  associatedtype ValueType

  var origin: ValueType { get }
  var spread: ValueType { get }
}

public struct EmitterValue<T>: EmitterValueType {
  typealias ValueType = T

  var origin: T
  var spread: T
}

extension EmitterValueType where ValueType == Int {
  var randomValue: Int {
    let value = CGFloat(origin) + random(location: CGFloat(spread) / -2.0, length: CGFloat(spread))

    return ValueType(value)
  }
}

extension EmitterValueType where ValueType == CGFloat {
  var randomValue: CGFloat {
    return origin + random(location: spread / -2.0, length: spread)
  }
}

extension EmitterValueType where ValueType == CGPoint {
  var randomValue: CGPoint {
    return origin + random(location: spread / -2.0, length: spread)
  }
}

extension EmitterValueType where ValueType == Angle {
  var randomValue: Angle {
    return origin + Angle(radians: random(location: spread.radians / -2.0, length: spread.radians))
  }
}

/// The properties of emitted particles.
public struct ParticleSystemProperties {
  /// The position at which particles should be emitted.
  public var position: EmitterValue<CGPoint> = EmitterValue(origin: .zero, spread: .zero)

  /// The lifetime (in frames) of emitted particles.
  public var lifetime: EmitterValue<Int> = EmitterValue(origin: 0, spread: 0)

  /// The angle at which particles should be emitted.
  var linearVelocityAngle: EmitterValue<Angle> = EmitterValue(origin: .zero, spread: .zero)

  /// The speed (in units per frame) at which particles should be emitted.
  var linearVelocitySpeed: EmitterValue<CGFloat> = EmitterValue(origin: 0, spread: 0)

  /// The initial angle of particles.
  var angle: EmitterValue<Angle> = EmitterValue(origin: .zero, spread: .zero)

  /// The angular velocity (in angle per frame) of emitted particles.
  var angularVelocity: EmitterValue<Angle> = EmitterValue(origin: .zero, spread: .zero)
}
