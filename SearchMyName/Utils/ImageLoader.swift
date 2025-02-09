//
//  ImageLoader.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/8/25.
//

import SwiftUI

@MainActor
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let session: URLSessionDataTasking
    
    init(session: URLSessionDataTasking = URLSession.shared) {
        self.session = session
    }
    
    func loadImage(from urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await session.data(from: url)
            if let image = UIImage(data: data) {
                self.image = image
            }
        } catch {
            print("Error loading image: \(error)")
        }
    }
}
