import Foundation

protocol AlertImageRepositoryProtocol {
    func saveImage(_ data: Data, for id: String)
    func getImage(for id: String) -> Data?
}

class AlertImageRepository: AlertImageRepositoryProtocol {
    private let cache = NSCache<NSString, NSData>()
    
    func saveImage(_ data: Data, for id: String) {
        cache.setObject(data as NSData, forKey: id as NSString)
    }
    
    func getImage(for id: String) -> Data? {
        cache.object(forKey: id as NSString) as Data?
    }
}
