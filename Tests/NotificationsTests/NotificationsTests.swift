import XCTest
@testable import Notifications

final class NotificationsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Notifications().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
