//
//  ResultBuilderTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 11/18/24.
//

import Foundation
import Testing

// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/advancedoperators/#Result-Builders
// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/attributes#resultBuilder
// https://github.com/swiftlang/swift-evolution/blob/main/proposals/0289-result-builders.md
// https://www.hackingwithswift.com/swift/5.4/result-builders

struct ResultBuilderTests {

    protocol Drawable {
        func draw() -> String
    }

    struct Line: Drawable {
        var elements: [Drawable]
        func draw() -> String {
            return elements.map { $0.draw() }.joined(separator: "")
        }
    }

    struct Text: Drawable {
        var content: String
        init(_ content: String) { self.content = content }
        func draw() -> String { return content }
    }

    struct Space: Drawable {
        func draw() -> String { return " " }
    }

    struct Stars: Drawable {
        var length: Int
        func draw() -> String { return String(repeating: "*", count: length) }
    }

    struct AllCaps: Drawable {
        var content: Drawable
        func draw() -> String { return content.draw().uppercased() }
    }

    @resultBuilder
    struct DrawingBuilder {
        static func buildBlock(_ components: Drawable...) -> Drawable {
            return Line(elements: components)
        }
        static func buildEither(first: Drawable) -> Drawable {
            return first
        }
        static func buildEither(second: Drawable) -> Drawable {
            return second
        }
        static func buildArray(_ components: [Drawable]) -> Drawable {
            return Line(elements: components)
        }
    }

    func draw(@DrawingBuilder content: () -> Drawable) -> Drawable {
        return content()
    }

    func caps(@DrawingBuilder content: () -> Drawable) -> Drawable {
        return AllCaps(content: content())
    }

    @Test func testManualDrawing() throws {
        let name: String? = "Ravi Patel"
        let manualDrawing = Line(elements: [
            Stars(length: 3),
            Text("Hello"),
            Space(),
            AllCaps(content: Text((name ?? "World") + "!")),
            Stars(length: 2),
        ])

        #expect(manualDrawing.draw() == "***Hello RAVI PATEL!**")
    }

    @Test func testDrawingBuilder() throws {

        func makeGreeting(for name: String? = nil) -> Drawable {
            let greeting = draw {
                Stars(length: 3)
                Text("Hello")
                Space()
                caps {
                    if let name = name {
                        Text(name + "!")
                    } else {
                        Text("World!")
                    }

                    // 위에 코드는 아래처럼 컴파일 된다.
                    //
                    // let partialDrawing: Drawable
                    // if let name = name {
                    //     let text = Text(name + "!")
                    //     partialDrawing = DrawingBuilder.buildEither(first: text)
                    // } else {
                    //     let text = Text("World!")
                    //     partialDrawing = DrawingBuilder.buildEither(second: text)
                    // }
                    // return partialDrawing
                }
                Stars(length: 2)
            }
            return greeting
        }

        #expect(makeGreeting().draw() == "***Hello WORLD!**")
        #expect(makeGreeting(for: "Ravi Patel").draw() == "***Hello RAVI PATEL!**")
    }

    @Test func testDrawingBuilderForLoop() throws {
        let stars = draw {
            Text("Stars:")
            for length in 1...3 {
                Space()
                Stars(length: length)
            }
        }

        #expect(stars.draw() == "Stars: * ** ***")
    }
}
