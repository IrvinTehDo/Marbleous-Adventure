//
//  BlockNode.swift
//  Marbleous Adventure
//
//  Created by student on 11/28/17.
//  Copyright © 2017 Irvin Do. All rights reserved.
//

import SpriteKit

class BlockNode: SKSpriteNode{
    func didMoveToScene(){
        physicsBody?.categoryBitMask = PhysicsCategory.Block
        physicsBody?.contactTestBitMask = PhysicsCategory.PlayerBottom | PhysicsCategory.MovingBlock
        physicsBody?.collisionBitMask = PhysicsCategory.Player
    }
}
