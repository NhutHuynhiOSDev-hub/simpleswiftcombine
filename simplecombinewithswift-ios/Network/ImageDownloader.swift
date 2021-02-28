//
//  ImageDownloader.swift
//  simplecombinewithswift-ios
//
//  Created by Nhut Huynh on 28/02/2021.
//

import Foundation
import UIKit

enum ImageDownloader {
    
    static func download(url: String, completion: @escaping (UIImage?) -> Void) {
        
        let url = URL(string: url)!
        URLSession.shared.dataTask(with: url) { data, response, error in
        
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let data = data, error == nil,
                  let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
}
