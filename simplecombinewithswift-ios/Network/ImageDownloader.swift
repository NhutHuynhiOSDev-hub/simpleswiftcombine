//
//  ImageDownloader.swift
//  simplecombinewithswift-ios
//
//  Created by Nhut Huynh on 28/02/2021.
//

import UIKit
import Combine
import Foundation


enum ImageDownloader {
    
    static func download(url: String) -> AnyPublisher<UIImage, GameError> {
    
        guard let url = URL(string: url) else {
        
            return Fail(error: GameError.invalidURL)
                .eraseToAnyPublisher()
            
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { response -> Data in
          
                guard let httpURLResponse = response.response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else { throw GameError.statusCode }
                return response.data
            }
            .tryMap { data in
          
                guard let image = UIImage(data: data) else { throw GameError.invalidImage }
                
                return image
            }
            .mapError { GameError.map($0) }
            .eraseToAnyPublisher()
    }

    
//    static func download(url: String, completion: @escaping (UIImage?) -> Void) {
//
//        let url = URL(string: url)!
//        URLSession.shared.dataTask(with: url) { data, response, error in
//
//            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                  let data = data, error == nil,
//                  let image = UIImage(data: data)
//            else {
//                completion(nil)
//                return
//            }
//            completion(image)
//        }.resume()
//    }
}
