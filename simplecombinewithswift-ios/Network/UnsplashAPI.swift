//
//  UnsplashAPI.swift
//  simplecombinewithswift-ios
//
//  Created by Nhut Huynh on 28/02/2021.
//

import Foundation

enum UnsplashAPI {
    
    static let  accessToken = "majoqpqXnAUdrFyYmxz9hnDVr-ckEp6YvaU-nxJs4BQs"
    static func randomImage(completion: @escaping (RandomImageResponse?) -> Void) {
        
        let url     = URL(string: "https://api.unsplash.com/photos/random/?client_id=\(accessToken)")!
        let config  = URLSessionConfiguration.default
        
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil

        let session = URLSession(configuration: config)

        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Accept-Version", forHTTPHeaderField: "v1")

        session.dataTask(with: urlRequest) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        
                let data = data, error == nil,
                let decodedResponse = try? JSONDecoder().decode(RandomImageResponse.self, from: data)
            else {
            
                completion(nil)
                return
            }
            
            completion(decodedResponse)
        }.resume()
    }
}
