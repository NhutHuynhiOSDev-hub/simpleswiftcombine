//
//  GameError.swift.swift
//  simplecombinewithswift-ios
//
//  Created by Nhut Huynh on 28/02/2021.
//

enum GameError: Error {
  
    case decoding
    case invalidURL
    case statusCode
    case invalidImage
    case other(Error)
  
    static func map(_ error: Error) -> GameError {
    
        return (error as? GameError) ?? .other(error)
    }
}
