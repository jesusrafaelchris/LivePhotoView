import Foundation

extension URL {
    static func tempFile(withFileExtension fileExtension: String) -> URL {
        let fileName = "\(NSUUID().uuidString).\(fileExtension)"
        let filePathString = (NSTemporaryDirectory() as NSString).appendingPathComponent(fileName)
        return URL(fileURLWithPath: filePathString)
    }
}
