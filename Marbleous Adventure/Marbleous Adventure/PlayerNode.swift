//
//  PlayerNode.swift
//  Marbleous Adventure
//
//  Created by student on 11/15/17.
//  Copyright © 2017 Irvin Do. All rights reserved.
//

import SpriteKit

class PlayerNode: SKSpriteNode{
    
    var canJump = true
    var groundNode: SKSpriteNode?
    
    func didMoveToScene() {
        //Draw and setup physicsbodies
        physicsBody!.categoryBitMask = PhysicsCategory.Player
        groundNode = childNode(withName:"playerBottom") as! SKSpriteNode
        groundNode!.physicsBody!.categoryBitMask = PhysicsCategory.PlayerBottom
    }
    
    
}
