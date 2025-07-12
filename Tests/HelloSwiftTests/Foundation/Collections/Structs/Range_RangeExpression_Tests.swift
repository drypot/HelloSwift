//
//  Range_RangeExpression_Tests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/2/24.
//

import Foundation
import Testing

struct Range_RangeExpression_Tests {

    @Test func testContains() throws {
        let range = 0..<5

        #expect((range ~= 3) == true)
        #expect((range ~= 5) == false)
        #expect((range ~= 6) == false)

        #expect(range.contains(3) == true)
        #expect(range.contains(5) == false)
        #expect(range.contains(6) == false)
    }

    @Test func testRelativeTo() throws {

        // 위나 아래가 열려있는 PartialRange 의 끝을 세팅한다.
        // https://stackoverflow.com/questions/45301490/what-does-the-relativeto-function-actually-do

        let numbers = [0, 1, 2, 3, 4, 5, 6]
        let numbersSuffix = numbers[3...] // [3, 4, 5, 6]

        // Half-open range 경우엔 변화가 없다.
        #expect((2..<4).relative(to: numbers) == 2..<4)

        // Closed range 는 Half-open 으로 변환된다.
        #expect((2...4).relative(to: numbers) == 2..<5)

        // Partial range 의 경우엔 컬렉션의 startIndex 나 endIndex 로 비었던 쪽이 채워진다.
        #expect((..<4).relative(to: numbers) == 0..<4)
        #expect((..<4).relative(to: numbersSuffix) == 3..<4)

        #expect((...4).relative(to: numbers) == 0..<5)

        #expect((2...).relative(to: numbers) == 2..<7)
        #expect((2...).relative(to: numbersSuffix) == 2..<7)

        // 적당 위치를 넘는 범위는 교정되지 않는다. 직접 처리해야 한다.
        #expect((..<14).relative(to: numbers) == 0..<14)
        #expect((..<14).relative(to: numbersSuffix) == 3..<14)

    }
}
