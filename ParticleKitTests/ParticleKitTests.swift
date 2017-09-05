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

    XCTAssertEqualWithAccuracy(floatValue.min, 7.4, accuracy: 0.01)
    XCTAssertEqualWithAccuracy(floatValue.max, 13, accuracy: 0.01)

    XCTAssertEqual(pointValue.min, CGPoint(x: 4, y: 8.5))
    XCTAssertEqual(pointValue.max, CGPoint(x: 6, y: 11.5))

    XCTAssertEqual(angleValue.min, Angle(radians: 2.5))
    XCTAssertEqual(angleValue.max, Angle(radians: 3.5))
  }
}
