import XCTest

import DiskStorageTests

var tests = [XCTestCaseEntry]()
tests += DiskStorageTests.allTests()
XCTMain(tests)
