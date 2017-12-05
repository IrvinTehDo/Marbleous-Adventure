//
//  MovingBlockNode.swift
//  Marbleous Adventure
//
//  Created by Irvin Do (RIT Student) on 12/4/17.
//  Copyright © 2017 Irvin Do. All rights reserved.
//

import SpriteKit

class MovingBlockNode: BlockNode{
    
    override func didMoveToScene() {
        physicsBody?.categoryBitMask = PhysicsCategory.MovingBlock
        physicsBody?.contactTestBitMask = PhysicsCategory.PlayerBottom | PhysicsCategory.Block
        physicsBody?.collisionBitMask = PhysicsCategory.Player
    }
    
}
