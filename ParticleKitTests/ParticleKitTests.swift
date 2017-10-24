// Copyright © 2017 Matt Comi. All rights reserved.

import XCTest
@testable import ParticleKit

class ParticleKitTests: XCTestCase {
  override func setUp() {
    super.setUp()
  }
    
  override func tearDown() {
    super.tearDown()
  }
    
  func testParticleSystemValue() {
    let intValue = ParticleSystemValue<Int>(origin: 10, spread: 5)
    let floatValue = ParticleSystemValue<CGFloat>(origin: 10.2, spread: 5.6)
    let pointValue = ParticleSystemValue<CGPoint>(origin: CGPoint(x: 5, y: 10), spread: CGPoint(x: 2, y: 3))
    let angleValue = ParticleSystemValue<Angle>(origin: Angle(radians: 3), spread: Angle(radians: 1))

    XCTAssertEqual(intValue.min, 7)
    XCTAssertEqual(intValue.max, 12)

    XCTAssertEqual(floatValue.min, 7.4, accuracy: 0.01)
    XCTAssertEqual(floatValue.max, 13, accuracy: 0.01)

    XCTAssertEqual(pointValue.min, CGPoint(x: 4, y: 8.5))
    XCTAssertEqual(pointValue.max, CGPoint(x: 6, y: 11.5))

    XCTAssertEqual(angleValue.min, Angle(radians: 2.5))
    XCTAssertEqual(angleValue.max, Angle(radians: 3.5))
  }

  func testCapacity() {
    let particleSystem = ParticleSystem(size: 3)
    particleSystem.properties.lifetime = ParticleSystemValue(origin: 100, spread: 0)
    particleSystem.properties.angularVelocity = ParticleSystemValue(origin: .zero, spread: .zero)

    // initially no particles
    XCTAssertEqual([Particle](particleSystem.particles).count, 0)

    for i in 0..<3 {
      particleSystem.properties.angle = ParticleSystemValue(origin: Angle(radians: CGFloat(i)), spread: .zero)
      particleSystem.emit()
    }

    XCTAssertEqual([Particle](particleSystem.particles).count, 3)

    for (i, particle) in particleSystem.particles.enumerated() {
      XCTAssertEqual(particle.remainingLifetime, 100)
      XCTAssertEqual(particle.angle, Angle(radians: CGFloat(i)))
    }

    particleSystem.update()

    for particle in particleSystem.particles {
      XCTAssertEqual(particle.remainingLifetime, 99)
    }

    particleSystem.properties.angle = ParticleSystemValue(origin: Angle(radians: 10), spread: .zero)

    // The particle system was at capacity so this should remove the oldest particle
    particleSystem.emit()

    XCTAssertEqual([Particle](particleSystem.particles).count, 3)

    XCTAssertEqual([Particle](particleSystem.particles).first!.angle.radians, 1)

    for _ in 0..<99 {
      particleSystem.update()
    }

    XCTAssertEqual([Particle](particleSystem.particles).count, 3)

    particleSystem.update()

    XCTAssertEqual([Particle](particleSystem.particles).count, 1)

    particleSystem.update()

    XCTAssertEqual([Particle](particleSystem.particles).count, 0)
  }

  func testRemoveAllParticles() {
    let particleSystem = ParticleSystem(size: 3)

    for _ in 0..<3 {
      particleSystem.emit()
    }

    XCTAssertEqual([Particle](particleSystem.particles).count, 3)

    particleSystem.removeAll()

    XCTAssertEqual([Particle](particleSystem.particles).count, 0)

    particleSystem.emit()

    XCTAssertEqual([Particle](particleSystem.particles).count, 1)
  }

  func testQuad() {
    var quad = Quad()

    quad.setPoint(index: 0, point: CGPoint(x: 10, y: 10))
    quad.setPoint(index: 1, point: CGPoint(x: 20, y: 10))
    quad.setPoint(index: 2, point: CGPoint(x: 20, y: 20))
    quad.setPoint(index: 3, point: CGPoint(x: 10, y: 20))

    // contains the left and top edge
    XCTAssert(quad.contains(point: CGPoint(x: 10, y: 15)))
    XCTAssert(quad.contains(point: CGPoint(x: 15, y: 10)))

    // does not contain the right or bottom edge
    XCTAssert(!quad.contains(point: CGPoint(x: 20, y: 15)))
    XCTAssert(!quad.contains(point: CGPoint(x: 15, y: 20)))

    XCTAssert(quad.contains(point: CGPoint(x: 15, y: 15)))
    XCTAssert(!quad.contains(point: CGPoint(x: 5, y: 15)))
    XCTAssert(!quad.contains(point: CGPoint(x: 25, y: 15)))
    XCTAssert(!quad.contains(point: CGPoint(x: 15, y: 5)))
    XCTAssert(!quad.contains(point: CGPoint(x: 15, y: 25)))
  }

  func testPerformance() {
    let particleSystem = ParticleSystem(size: 1024)

    autoreleasepool {
      measure {
        for _ in 0..<1024 {
          for _ in 0..<10 {
            particleSystem.emit()
          }

          particleSystem.update()
        }
      }
    }
  }
}
