import XCTest
import Await

@testable import DiskStorage

final class DiskStorageTests: XCTestCase {
  func testStorage() async throws {
    struct Timeline: Codable, Equatable {
      let tweets: [String]
    }

    let path = URL(fileURLWithPath: NSTemporaryDirectory())
    let storage = DiskStorage(path: path)

    let timeline = Timeline(tweets: ["Hello", "World", "!!!"])

    await storage.write(timeline, for: "timeline")

    let result = await storage.read(Timeline.self, for: "timeline")

    switch (result) {
      case .failure(let error):
        XCTFail("Error: \(error)")
      case .success(let result):
        print(try result.prettify())
        XCTAssertEqual(result, timeline)
    }
  }
}
