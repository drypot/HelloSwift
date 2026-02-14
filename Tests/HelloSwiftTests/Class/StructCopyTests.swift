//
//  StructCopyTests.swift
//  Tests
//
//  Created by drypot on 2024-04-06.
//

import Testing

struct StructCopyTests {

    @Test func testStructCopy() throws {
        struct T {
            var p = 1
        }
        
        let a = T()
        var b = a

        b.p = 2

        #expect(a.p == 1)
        #expect(b.p == 2)
    }
    
    @Test func testStructDeepCopy() throws {
        struct T {
            var p: [Int] = [1, 2]
        }
        
        let a = T()
        var b = a
        
        b.p.append(3)
        
        #expect(a.p == [1, 2])
        #expect(b.p == [1, 2, 3])
    }

    @Test func testStructDeepCopy2() throws {
        struct T {
            var p: [[Int]] = [[1, 2], [3, 4]]
        }

        let a = T()
        var b = a

        b.p[0].append(9)
        b.p.append([5, 6])

        #expect(a.p == [[1, 2], [3, 4]])
        #expect(b.p == [[1, 2, 9], [3, 4], [5, 6]])
    }

    @Test func testClassCopy() throws {
        class T {
            var p = 1
        }

        let a = T()
        let b = a

        b.p = 2

        #expect(a.p == 2)
        #expect(b.p == 2)
    }

}
