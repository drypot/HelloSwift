//
//  CollectionIndexTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/10/24.
//

import Foundation
import Testing

struct CollectionIndexTests {

    @Test func testStartIndex() throws {
        let numbers = [Int]()

        #expect(numbers.isEmpty == true)
        #expect(numbers.startIndex == 0)
        #expect(numbers.endIndex == 0)
    }

    @Test func testIndexAfter() throws {
        let numbers = [10, 20, 30, 40, 50]
        var copy = [Int]()

        var index = numbers.startIndex
        while index != numbers.endIndex {
            copy.append(numbers[index])
            index = numbers.index(after: index)
        }

        #expect(copy == numbers)
    }

    @Test func testFormIndex() throws {
        let numbers = [10, 20, 30, 40, 50]
        var copy = [Int]()

        var index = numbers.startIndex
        while index != numbers.endIndex {
            copy.append(numbers[index])
            numbers.formIndex(after: &index)
        }

        #expect(copy == numbers)
    }

    @Test func testIndexRange() throws {
        let numbers = [10, 20, 30, 40, 50]

        guard let firstIndex = numbers.firstIndex(of: 30) else { fatalError() }

        #expect(numbers[firstIndex ..< numbers.endIndex] == [30, 40, 50])
    }

    @Test func testIndices() throws {
        let numbers = [10, 20, 30, 40, 50]

        #expect(numbers.indices == 0..<5)

        // indices 는 구현에 따라 strong reference 를 만들 수 있고
        // 그러다 잘못하면 예상치 못한 컬렉션 복제 상황을 만들 수도 있으므로
        // 왠만하면 쓰지 말라고 한다.
        // https://developer.apple.com/documentation/swift/defaultindices
    }

}
