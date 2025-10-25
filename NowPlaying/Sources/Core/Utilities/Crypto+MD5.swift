import Foundation
import CryptoKit

extension Data {
    var hex: String { map { String(format: "%02x", $0) }.joined() }
}

func md5Hex(_ s: String) -> String {
    let digest = Insecure.MD5.hash(data: Data(s.utf8))
    return Data(digest).hex
}
