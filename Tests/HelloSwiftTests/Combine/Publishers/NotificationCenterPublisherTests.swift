//
//  Counter.swift
//  HelloSwift
//
//  Created by Kyuhyun Park on 12/8/24.
//

import Foundation
import Combine
import HelloSwift
import Testing

struct NotificationCenterPublisherTests {

    @Test func testNotificationCenterPublisher() throws {
        let logger = SimpleLogger<Int>()
        var cancellables = Set<AnyCancellable>()

        let customNotification = Notification.Name("CustomNotification")

        NotificationCenter.default.publisher(for: customNotification)
            // compatMap 은 nil 값을 제외한다.
            .compactMap { notification in
                notification.userInfo?["mark"] as? Int
            }
            .sink { value in
                logger.log(value)
            }
            .store(in: &cancellables)

        NotificationCenter.default.post(
            name: customNotification,
            object: nil,
            userInfo: ["mark" : 99]
        )

        #expect(logger.result() == [99])
    }

}
