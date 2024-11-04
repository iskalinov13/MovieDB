//
//  NetworkingManager.swift
//  MovieDB
//
//  Created by FIskalinov on 04.11.2024.
//

import Foundation
import UIKit

class NetworkingManager {
    static let shared = NetworkingManager()
    private let apiKey = "9b1d955719ec36efd4ec53f4e36c5d6b"
    
    private let imageUrl = "https://image.tmdb.org/t/p/w500"
    private let urlString = "https://api.themoviedb.org/3/movie/now_playing"
    //private let imageUrl = "https://image.tmdb.org/t/p/w500"
    
    private let session = URLSession(configuration: .default)
    
    private lazy var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        return components
    }()
    
    init() {}
}


extension NetworkingManager {
    func getMovies(completion: @escaping ([Movie]) -> Void) {
        urlComponents.path = "/3/movie/now_playing"
        guard let url = urlComponents.url else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data, let response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            print(response)
            
            do {
                let datas = try JSONDecoder().decode(Movies.self, from: data)
                DispatchQueue.main.async {
                    completion(datas.results)
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func loadImage(porterPath: String, completion: @escaping (UIImage) -> ()) {
        guard let url = URL(string: imageUrl + porterPath) else { return }
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let task = session.dataTask(with: url) { data, _, error in
                if let error {
                    print(error)
                }
                
                guard let data else { return }
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        completion(image)
                    }
                }
            }
            task.resume()
        }
    }
    
}
