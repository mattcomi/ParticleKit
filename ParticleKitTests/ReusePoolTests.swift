// Copyright © 2017 Matt Comi. All rights reserved.

import XCTest
import ParticleKit

class Number: ReusePoolElement, CustomStringConvertible, Equatable {
  var number: Int = 0

  required init() {
  }

  init(_ number: Int) {
    self.number = number
  }

  var reusePoolItem: ReusePoolItem?

  func prepareForReuse() {
    number = 0
  }

  var description: String {
    return "\(number)"
  }

 static func ==(lhs: Number, rhs: Number) -> Bool {
    return lhs.number == rhs.number
  }
}

class ReusePoolTests: XCTestCase {
  override func setUp() {
    super.setUp()
  }
    
  override func tearDown() {
    super.tearDown()
  }
    
  func testReusePool() {
    // create a pool with 50 elements
    let pool = ReusePool<Number>(size: 50)

    // assert that all elements are available
    XCTAssertEqual(pool.numberOfAvailableElements, 50)
    XCTAssertEqual(pool.numberOfUnavailableElements, 0)

    XCTAssertEqual([Number](pool.availableElements).count, 50)
    XCTAssertEqual([Number](pool.unavailableElements).count, 0)

    // dequeue each element
    for i in 0..<50 {
      guard let number = pool.dequeueFirstAvailable() else {
        XCTFail()
        return
      }

      number.number = i
    }

    // assert that all elements are unavailable
    XCTAssertEqual([Number](pool.availableElements).count, 0)
    XCTAssertEqual([Number](pool.unavailableElements).count, 50)

    XCTAssertEqual([Number](pool.availableElements).count, 0)
    XCTAssertEqual([Number](pool.unavailableElements).count, 50)

    // assert that the unavailable elements are sorted in the order that they were dequeued
    for (i, number) in pool.unavailableElements.enumerated() {
      XCTAssertEqual(i, number.number)
    }

    // enumerate the sequence and enqueue 3 items
    for (i, number) in pool.unavailableElements.enumerated() {
      if i == 10 || i == 20 || i == 30 {
        pool.enqueue(number)
      }
    }

    // assert that those 3 items are available
    XCTAssertEqual([Number](pool.availableElements), [Number(30), Number(20), Number(10)])
    XCTAssertEqual(pool.numberOfAvailableElements, 3)

    XCTAssertEqual([Number](pool.unavailableElements).count, 47)
    XCTAssertEqual(pool.numberOfUnavailableElements, 47)

    // assert that 9 and 11 are now neighbouring unavailable elements
    XCTAssertEqual([Number](pool.unavailableElements)[9], Number(9))
    XCTAssertEqual([Number](pool.unavailableElements)[10], Number(11))

    guard let firstNumber = pool.unavailableElements.first(where: { return $0.number == 0 }) else {
      XCTFail()
      return
    }

    // enqueue the first unavailable element and assert that it is no longer unavailable
    pool.enqueue(firstNumber)

    XCTAssertEqual([Number](pool.unavailableElements)[0], Number(1))
    XCTAssertEqual([Number](pool.unavailableElements).count, 46)
    XCTAssertEqual([Number](pool.availableElements)[0], Number(0))

    guard let lastNumber = pool.unavailableElements.first(where: { return $0.number == 49 }) else {
      XCTFail()
      return
    }

    // enqueue the last unavailable element and assert that it is no longer unavailable
    pool.enqueue(lastNumber)

    XCTAssertEqual([Number](pool.unavailableElements)[44], Number(48))
    XCTAssertEqual([Number](pool.unavailableElements).count, 45)
    XCTAssertEqual([Number](pool.availableElements)[0], Number(49))

    XCTAssertEqual([Number](pool.availableElements), [Number(49), Number(0), Number(30), Number(20), Number(10)])

    // dequeue the first *unavailable* element
    guard let number = pool.dequeueFirstUnavailable() else {
      XCTFail()
      return
    }

    // assert that the number of available and unavailable elements is unchanged
    XCTAssertEqual(pool.numberOfAvailableElements, 5)
    XCTAssertEqual(pool.numberOfUnavailableElements, 45)

    number.number = 100

    XCTAssertEqual([Number](pool.unavailableElements)[0], Number(2))
    XCTAssertEqual([Number](pool.unavailableElements)[1], Number(3))

    // assert that the dequeued unavailable element has been moved to the back of the unavailable queue
    XCTAssertEqual([Number](pool.unavailableElements)[44], Number(100))

    XCTAssertEqual([Number](pool.availableElements)[0], Number(49))
    XCTAssertEqual([Number](pool.availableElements)[4], Number(10))
  }
}
