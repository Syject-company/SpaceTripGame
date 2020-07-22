//
//  GameViewController.swift
//  SpaceTrip
//
//  Created by Kostya Bershov on 17.02.2020.
//  Copyright © 2020 Syject. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController, GADInterstitialDelegate {
    
    private struct Constants {
        static let sceneTransistionDuration: Double = 0.2
    }
    
    private var gameScene: GameScene?
    var interstitial: GADInterstitial!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        startNewGame(animated: false)
        interstitial = createAndLoadInterstitial()
        // Start the background music
        MusicManager.shared.playBackgroundMusic()
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
      var interstitial = GADInterstitial(adUnitID: "ca-app-pub-2544925861499545/4328807499")
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }
    
    // MARK: - Appearance

    override var shouldAutorotate : Bool {
        return true
    }

    // Make sure only the landscape mode is supported
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }

    override var prefersStatusBarHidden : Bool {
        // Hide the status bar
        return true
    }
    
}

// MARK: - Scene handling

extension GameViewController {
    
    private func startNewGame(animated: Bool = false) {
        // Recreate game scene
        gameScene = GameScene(size: view.frame.size)
        gameScene!.scaleMode = .aspectFill
        gameScene!.gameSceneDelegate = self
        
        show(gameScene!, animated: animated)
    }
    
    private func resumeGame(animated: Bool = false, completion:(()->())? = nil) {
        let skView = view as! SKView
        
        if animated {
            // Show game scene
            skView.presentScene(gameScene!,
                                transition: SKTransition.crossFade(withDuration: Constants.sceneTransistionDuration))
            
            // Remove the menu scene and unpause the game scene after it was shown
            let delay = Constants.sceneTransistionDuration * Double(NSEC_PER_SEC)
            let time = DispatchTime.now() + delay / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: time, execute: { [weak self] in
                self?.gameScene!.isPaused = false
                
                // Call completion handler
                completion?()
            })
        }
        else {
            // Remove the menu scene and unpause the game scene after it was shown
            skView.presentScene(gameScene!)
            gameScene!.isPaused = false

            // Call completion handler
            completion?()
        }
    }
    
    private func showMainMenuScene(animated: Bool) {
        // Create main menu scene
        let scene = MainMenuScene(size: view.frame.size)
        scene.mainMenuSceneDelegate = self
        
        // Pause the game
        gameScene!.isPaused = true
        
        // Show it
        show(scene, animated: animated)
    }
    
    private func showGameOverScene(animated: Bool) {
        // Create game over scene
        gameScene!.isPaused = true
        
        if interstitial.isReady {
          interstitial.present(fromRootViewController: self)
        } else {
          print("Ad wasn't ready")
            let scene = GameOverScene(size: view.frame.size)
            scene.gameOverSceneDelegate = self
      //      gameScene!.isPaused = true
            show(scene, animated: animated)
        }
    }

    private func show(_ scene: SKScene, scaleMode: SKSceneScaleMode = .aspectFill, animated: Bool = true) {
        guard let skView = view as? SKView else {
            preconditionFailure()
        }

        scene.scaleMode = .aspectFill

        if animated {
            skView.presentScene(scene, transition: SKTransition.crossFade(withDuration: Constants.sceneTransistionDuration))
        } else {
            skView.presentScene(scene)
        }
    }
    
}

// MARK: - GameSceneDelegate

extension GameViewController : GameSceneDelegate {

    func didTapMainMenuButton(in gameScene: GameScene) {
        // Show initial, main menu scene
        showMainMenuScene(animated: true)
    }
    
    func playerDidLose(withScore score: Int, in gameScene:GameScene) {
        showGameOverScene(animated: true)
    }
    
}

// MARK: - MainMenuSceneDelegate

extension GameViewController : MainMenuSceneDelegate {
    
    func mainMenuSceneDidTapResumeButton(_ mainMenuScene: MainMenuScene) {
        resumeGame(animated: true) {
            // Remove main menu scene when game is resumed
            mainMenuScene.removeFromParent()
        }
    }
    
    func mainMenuSceneDidTapRestartButton(_ mainMenuScene: MainMenuScene) {
        startNewGame(animated: true)
    }
    
    func mainMenuSceneDidTapInfoButton(_ mainMenuScene:MainMenuScene) {
        // Create a simple alert with copyright information
        let alertController = UIAlertController(title: "About",
                                                message: "Copyright 2020 Kostya Bershov. All rights reserved.",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        // Show it
        present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - GameOverSceneDelegate

extension GameViewController : GameOverSceneDelegate {
    
    func gameOverSceneDidTapRestartButton(_ gameOverScene: GameOverScene) {
        // TODO: Remove game over scene here
        startNewGame(animated: true)
    }
    
}

// MARK: - Configuration

extension GameViewController {
    
    private func configureView() {
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        
        // Enable debugging
        #if DEBUG
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = true
        #endif
    }
    
}

extension GameViewController {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
      print("interstitialDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
      print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
      print("interstitialWillPresentScreen")
    }

    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
      print("interstitialWillDismissScreen")
    }

    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
      print("interstitialDidDismissScreen")
        
        let scene = GameOverScene(size: view.frame.size)
        scene.gameOverSceneDelegate = self
        
        // Pause the game
     //   gameScene!.isPaused = true
        
        // Show it
        show(scene, animated: true)
        
    }

    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
      print("interstitialWillLeaveApplication")
    }
}
