//
//  StructTests.swift
//  Tests
//
//  Created by drypot on 2024-04-06.
//

import Testing

struct StructTests {

    @Test func testStructCopy() throws {
        struct T {
            var p = "x"
        }
        
        let a = T()
        var b = a // *** var
        
        b.p = "y"
        
        #expect(a.p == "x") // *** x
    }
    
    @Test func testClassCopy() throws {
        class T {
            var p = "x"
        }
        
        let a = T()
        let b = a  // *** let
        
        b.p = "y"
        
        #expect(a.p == "y") // *** y
    }
    
    @Test func testStructDeepCopy() throws {
        struct T {
            var p: [Int] = [1, 2]
        }
        
        let a = T()
        var b = a // *** var
        
        b.p.append(3)
        
        #expect(a.p.count == 2) // *** 2
        #expect(b.p.count == 3)
    }
    
    @Test func testClassDeepCopy() throws {
        class T {
            var p: [Int] = [1, 2]
        }
        
        let a = T()
        let b = a // *** let
        
        b.p.append(3)
        
        #expect(a.p.count == 3) // *** 3
        #expect(b.p.count == 3)
    }
    
    @Test func testStructDeepCopy2() throws {
        struct T {
            var p: [[Int]] = [[1, 2]]
        }
        
        let a = T()
        var b = a // *** var
        
        b.p[0].append(3)
        
        #expect(a.p[0].count == 2) // *** 2
        #expect(b.p[0].count == 3)
    }
    
    @Test func testClassDeepCopy2() throws {
        class T {
            var p: [[Int]] = [[1, 2]]
        }
        
        let a = T()
        let b = a // *** let
        
        b.p[0].append(3)
        
        #expect(a.p[0].count == 3) // *** 3
        #expect(b.p[0].count == 3)
    }
    
}
