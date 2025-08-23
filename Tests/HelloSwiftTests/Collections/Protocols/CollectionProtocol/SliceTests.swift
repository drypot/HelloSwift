//
//  SliceTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/10/24.
//

import Foundation
import Testing

// Slice: A view into a subsequence of elements of another collection.
// https://developer.apple.com/documentation/swift/slice

// Slice 는 베이스 엘리먼트를 복제하지 않는다.
// Slice 생성은 O(1) complexity.

// Slice 의 인덱스는 base 와 같은 인덱스 좌표 공간을 사용한다.
// Slice 의 인덱스를 base 에 사용 가능하다.

struct SliceTests {

    @Test func testSlice() throws {
        let collection = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        var slice:Array<Int>.SubSequence

        slice = collection.dropFirst(3)

        #expect(slice.count == 7)
        #expect(slice == [3, 4, 5, 6, 7, 8, 9])

        #expect(slice.startIndex == 3)
        #expect(slice.endIndex == 10)

        slice = slice.dropLast(3)

        #expect(slice.count == 4)
        #expect(slice == [3, 4, 5, 6])

        #expect(slice.startIndex == 3)
        #expect(slice.endIndex == 7)
    }

}
