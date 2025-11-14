//
//  RecordTests.swift
//  HelloSwiftTests
//
//  Created by Kyuhyun Park on 12/2/24.
//

import Foundation
import Combine
import HelloSwift
import Testing

struct RecordTests {

    @Test func testRecord() throws {
        let logger = SimpleLogger<Int>()
        var cancellables = Set<AnyCancellable>()

        // Record 는 이미 만들어져 있는 데이터를 publish 한다.

        Record<Int, Never>(output: [1, 2, 3, 4, 5], completion: .finished)
            .sink(
                receiveCompletion: { completion in
                    logger.log(99)
                },
                receiveValue: { value in
                    logger.log(value)
                }
            )
            .store(in: &cancellables)

        #expect(logger.result() == [1, 2, 3, 4, 5, 99])
    }

    @Test func testRecording() throws {
        let logger = SimpleLogger<Int>()
        var cancellables = Set<AnyCancellable>()

        // 여타 이벤트로 발생하는 값들을 publish 할 수 있다.
        // Record.init 에 바로 sink 를 붙여도 되고,
        // Record.recording 에 기록만 한 후
        // Record.recording 을 여러 번 재사용할 수도 있다.

        let record = Record<Int, Never> { recording in
            for value in [1, 2, 3, 4, 5] {
                recording.receive(value)
            }
            recording.receive(completion: .finished)
        }

        Record<Int, Never>(recording: record.recording)
            .sink(
                receiveCompletion: { completion in
                    logger.log(99)
                },
                receiveValue: { value in
                    logger.log(value)
                }
            )
            .store(in: &cancellables)

        Record<Int, Never>(recording: record.recording)
            .sink(
                receiveCompletion: { completion in
                    logger.log(99)
                },
                receiveValue: { value in
                    logger.log(value)
                }
            )
            .store(in: &cancellables)

        #expect(logger.result() == [1, 2, 3, 4, 5, 99, 1, 2, 3, 4, 5, 99])
    }

}
