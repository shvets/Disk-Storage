import XCTest
import Files

@testable import DiskStorage

class ConfigFileTests: XCTestCase {
  static let fileName = "test.config"

  let subject: ConfigFile<String> = {
    let path = URL(fileURLWithPath: NSTemporaryDirectory())

    return ConfigFile<String>(path: path, fileName: fileName)
  }()

  func testSave() async throws {
    //try File(path: subject.fileName).delete()

    subject.items["key1"] = "value1"
    subject.items["key2"] = "value2"

    let result = await subject.write()

    switch (result) {
      case .failure(let error):
        XCTFail("Error: \(error)")
      case .success(let items):
        print(try items.prettify())
        XCTAssertEqual(items.keys.count, 2)
    }
  }

  func testLoad() async throws {
    let data = "{\"key1\": \"value1\", \"key2\": \"value2\"}".data(using: .utf8)

    let folder = try Folder(path: ".")
    try folder.createFile(named: ConfigFileTests.fileName, contents: data!)

    let result = await subject.read()

    switch (result) {
      case .failure(let error):
        XCTFail("Error: \(error)")
      case .success(let items):
        print(try items.prettify())
        XCTAssertEqual(items.keys.count, 2)
    }
  }
}
