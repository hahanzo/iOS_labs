//
//  SpaceImageViewModel.swift
//  lab4
//
//  Created by IPZ-31 on 21.11.2024.
//

import Foundation
import Combine

class SpaceImageViewModel: ObservableObject {
    @Published var spaceImages: [SpaceImage] = []
        @Published var errorMessage: String?
        @Published var isLoading: Bool = false
        private var currentPage = 1
        private let itemsPerPage = 10
        
        func fetchSpaceImageData() {
            guard !isLoading else { return }  // Запобігаємо подвійним запитам
            
            isLoading = true
            let urlString = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&count=\(10)"
            
            guard let url = URL(string: urlString) else {
                self.errorMessage = "Invalid URL"
                return
            }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.errorMessage = error.localizedDescription
                        self?.isLoading = false
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self?.errorMessage = "No data received"
                        self?.isLoading = false
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let images = try decoder.decode([SpaceImage].self, from: data)
                    
                    DispatchQueue.main.async {
                        self?.spaceImages.append(contentsOf: images)
                        self?.currentPage += 1  // Оновлюємо поточну сторінку
                        self?.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Failed to decode JSON: \(error)"
                        self?.isLoading = false
                    }
                }
            }.resume()
        }
}
