import SwiftUI
import UIKit // нужно для работы с UIImage

class ImageLoader: ObservableObject {
    @Published var image: UIImage? = nil
    
    func loadImage(with url: URL) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                if let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = uiImage
                    }
                } else {
                    print("Failed to decode image data")
                }
            } catch {
                print("Error loading image: \(error)")
            }
        }
    }
}

