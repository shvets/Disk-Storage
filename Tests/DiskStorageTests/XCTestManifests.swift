import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(DiskStorageTests.allTests),
    ]
}
#endif
