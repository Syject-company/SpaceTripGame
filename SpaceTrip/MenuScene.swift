//
//  MenuScene.swift
//  SpaceTrip
//
//  Created by Kostya Bershov on 17.02.2020.
//  Copyright © 2020 Syject. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    private var background: SKSpriteNode?

    // MARK: - Scene lifecycle
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        configureBackground()
    }
    
    // MARK: - Configuration

    private func configureBackground() {
        background = SKSpriteNode(imageNamed: ImageName.MenuBackgroundPhone.rawValue)
        background!.size = size
        background!.position = CGPoint(x: size.width/2, y: size.height/2)
        background!.zPosition = -1000
        addChild(background!)
    }
    
}
