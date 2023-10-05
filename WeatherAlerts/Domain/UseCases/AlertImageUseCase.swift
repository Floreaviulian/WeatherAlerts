import UIKit

protocol AlertImageUseCaseProtocol {
    func saveImage(_ data: Data, for id: String)
    func getImage(for id: String) -> AlertImage
}

class AlertImageUseCase: AlertImageUseCaseProtocol {
    private let repository: AlertImageRepositoryProtocol
    
    init(repository: AlertImageRepositoryProtocol = AlertImageRepository()) {
        self.repository = repository
    }
    
    func saveImage(_ data: Data, for id: String) {
        repository.saveImage(data, for: id)
    }
    
    func getImage(for id: String) -> AlertImage {
        if let data = repository.getImage(for: id), let image = UIImage(data: data) {
            return .image(image)
        } else {
            return .url(URL(string: "https://picsum.photos/1000")!)
        }
    }
}
