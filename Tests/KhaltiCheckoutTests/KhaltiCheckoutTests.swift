import XCTest
@testable import KhaltiCheckout

final class KhaltiCheckoutTests: XCTestCase {
    
    func testKhaltiPayConfigInitialization() {
        let config = KhaltiPayConfig(
            publicKey: "test_public_key",
            pIdx: "test_pidx",
            openInKhalti: false,
            environment: .TEST
        )
        
        XCTAssertEqual(config.publicKey, "test_public_key")
        XCTAssertEqual(config.pIdx, "test_pidx")
        XCTAssertFalse(config.openInKhalti)
        XCTAssertEqual(config.environment, .TEST)
    }
    
    func testEnvironmentEnum() {
        XCTAssertEqual(Environment.PROD.rawValue, 0)
        XCTAssertEqual(Environment.TEST.rawValue, 1)
    }
}