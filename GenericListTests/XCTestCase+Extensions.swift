import XCTest

extension XCTestCase {
    func XCTAssertNotHaveMemoryLeak(
        _ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line
    ) {
        let instanceDescribed = String(describing: instance.self)
        addTeardownBlock { [weak instance] in
            XCTAssertNil(
                instance, "Potencial memory leak for \(instanceDescribed)",
                file: file, line: line
            )
        }
    }
}
