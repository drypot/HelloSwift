//
//  MainActorTests.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 11/14/24.
//

import Foundation
import Testing

// https://developer.apple.com/documentation/swift/mainactor
// A singleton actor whose executor is equivalent to the main dispatch queue.

// @MainActor 붙은 평션이 있을 때

@MainActor fileprivate func assertMainActor() {
    // @MainActor 붙은 펑션의 코드는 main thread 에서 실행된다.
}

struct MainActorTests {

    // nonisolated sync 펑션에서 @MainActor 펑션 부르려면 컴파일 에러.
    nonisolated func nonisolatedFunc() {
        //assertMainActor()
    }

    // nonisolated async 펑션에서 @MainActor 펑션 부르려면 await.
    nonisolated func nonisolatedAsyncFunc() async {
        await assertMainActor()
    }

    // MainActor 펑션에서 MainActor 펑션 부르려면 await 빼야 한다.
    @MainActor func mainActorFunc() {
        assertMainActor()
    }

    // @MainActor async 펑션에서 MainActor 펑션 부르려면 await 빼야 한다.
    @MainActor func mainActorAsyncFunc() async {
        assertMainActor()
    }

    @Test func testMainActorRun() throws {
        Task {
            await MainActor.run {
                // 여기 코드는 main thread 에서 실행된다.
            }
        }
    }

    @Test func testMainActorRunAsync() async throws {
        await MainActor.run {
            // 여기 코드는 main thread 에서 실행된다.
        }
    }

}
