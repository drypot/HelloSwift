//
//  RetainingTimeTest.swift
//  HelloSwiftTesting
//
//  Created by drypot on 2024-04-05.
//

// 참고
// https://swiftrocks.com/memory-management-and-performance-of-value-types

import Foundation
import Testing

struct RetainingTimeTest {
    
    final class EmptyClass {}
    
    class HugeClass {
        var emptyClass = EmptyClass()
        var emptyClass2 = EmptyClass()
        var emptyClass3 = EmptyClass()
        var emptyClass4 = EmptyClass()
        var emptyClass5 = EmptyClass()
        var emptyClass6 = EmptyClass()
        var emptyClass7 = EmptyClass()
        var emptyClass8 = EmptyClass()
        var emptyClass9 = EmptyClass()
        var emptyClass10 = EmptyClass()
    }
    
    struct HugeStruct {
        var emptyClass = EmptyClass()
        var emptyClass2 = EmptyClass()
        var emptyClass3 = EmptyClass()
        var emptyClass4 = EmptyClass()
        var emptyClass5 = EmptyClass()
        var emptyClass6 = EmptyClass()
        var emptyClass7 = EmptyClass()
        var emptyClass8 = EmptyClass()
        var emptyClass9 = EmptyClass()
        var emptyClass10 = EmptyClass()
    }
    
    struct MiniStruct {
        var emptyClass = EmptyClass()
        var emptyClass2 = EmptyClass()
        var emptyClass3 = EmptyClass()
        var emptyClass4 = EmptyClass()
    }
    
    let count = 10_000_000
    
    func createClass() {
        var array = [HugeClass]()
        let object = HugeClass()
        for _ in 0..<count {
            array.append(object)
        }
    }
    
    func createStruct() {
        var array = [HugeStruct]()
        let object = HugeStruct()
        for _ in 0..<count {
            array.append(object)
        }
    }
    
    func createMiniStruct() {
        var array = [MiniStruct]()
        let object = MiniStruct()
        for _ in 0..<count {
            array.append(object)
        }
    }

    // https://developer.apple.com/documentation/swift/continuousclock
    // https://developer.apple.com/documentation/swift/continuousclock/instant/duration

    func interval(_ work: () throws -> Void) rethrows -> String {
        let clock = ContinuousClock()
        let result = try clock.measure(work)
        return result.formatted(.units(allowed: [.seconds, .milliseconds]))
    }
    
    @Test func benchmarkRetainingTime() {
        print("bench start")
        print("class \(interval(createClass))")
        print("struct \(interval(createStruct))")
        print("mini struct \(interval(createMiniStruct))")
        print("bench end")
    }
    
}
