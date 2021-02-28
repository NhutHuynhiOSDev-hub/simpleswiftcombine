//
//  GameViewController.swift
//  simplecombinewithswift-ios
//
//  Created by Nhut Huynh on 28/02/2021.
//

import UIKit
import Combine

enum GameState {
    
    case play
    case stop
}

class GameViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var gameStateButton: UIButton!

    @IBOutlet weak var gameScoreLabel: UILabel!

    @IBOutlet var gameImageView: [UIImageView]!

    @IBOutlet var gameImageButton: [UIButton]!

    @IBOutlet var gameImageLoader: [UIActivityIndicatorView]!
    
    
    // MARK: - Variables
    var gameState: GameState = .stop {
        didSet {
          switch gameState {
        
                case .play: playGame()
                case .stop: stopGame()
            }
        }
    }

    var gameLevel = 0
    var gameScore = 0
    
    var gameImages      : [UIImage] = []
    var gameTimer       : AnyCancellable?
    var subscriptions   : Set<AnyCancellable> = []
    
    // MARK: - Game Actions
    @IBAction func playOrStopAction(sender: UIButton) {
    
        gameState = gameState == .play ? .stop : .play
      
    }
    
    @IBAction func imageButtonAction(sender: UIButton) {
   
        let selectedImages = gameImages.filter { $0 == gameImages[sender.tag] }
      
        if selectedImages.count == 1 {
            
            playGame()
        } else { gameState = .stop }
    }
    
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        precondition(!UnsplashAPI.accessToken.isEmpty, "Please provide a valid Unsplash access token!")

        title               = "Find or Lose"
        gameScoreLabel.text = "Score: \(gameScore)"
    }
    
    
    // MARK: - Game Functions
    func playGame() {
        
        self.gameTimer = Timer.publish(every: 0.1, on: RunLoop.main, in: .common)
          .autoconnect()
          .sink { [unowned self] _ in
          
            self.gameScoreLabel.text = "Score: \(self.gameScore)"
            self.gameScore -= 10

            if self.gameScore < 0 {
                
                self.gameScore = 0
                self.gameTimer?.cancel()
            }
        }

        
        let firstImage = UnsplashAPI.randomImage()
          .flatMap { randomImageResponse in
            
            ImageDownloader.download(url: randomImageResponse.urls.regular)
          }
        
        let secondImage = UnsplashAPI.randomImage()
            .flatMap { randomImageResponse in
           
                ImageDownloader.download(url: randomImageResponse.urls.regular)
          }
        
        firstImage.zip(secondImage)
          .receive(on: DispatchQueue.main)
          .sink(receiveCompletion: { [unowned self] completion in
            
            switch completion {

                case .finished  : break
                case .failure (let error):
                  
                    print("Error: \(error)")
                    self.gameState = .stop
                }
          }, receiveValue: { [unowned self] first, second in
            
            self.gameImages = [first, second, second, second].shuffled()
            self.gameScoreLabel.text = "Score: \(self.gameScore)"

            self.stopLoaders()
            self.setImages()
          })
            .store(in: &subscriptions)
    }

  func stopGame() {
    
    subscriptions.forEach { $0.cancel() }
    
    self.gameTimer?.cancel()
    gameStateButton.setTitle("Play", for: .normal)

    title = "Find or Lose"

    gameLevel = 0
    gameScore = 0
    gameScoreLabel.text = "Score: \(gameScore)"

    stopLoaders()
    resetImages()
  }

    
  // MARK: - UI Functions
    func setImages() {
        if gameImages.count == 4 {
      
            for (index, gameImage) in gameImages.enumerated() { gameImageView[index].image = gameImage }
        }
    }

    func resetImages() {
    
        gameImages      = []
        subscriptions   = []
        gameImageView.forEach { $0.image = nil }
    }
  
    func startLoaders() { gameImageLoader.forEach { $0.startAnimating() } }
    func stopLoaders() { gameImageLoader.forEach { $0.stopAnimating() } }
}

