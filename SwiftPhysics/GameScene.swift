//
//  GameScene.swift
//  SwiftPhysics
//
//  Created by Peter D. Neisen on 6/24/14.
//  Copyright (c) 2014 Pete Neisen. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var currentPath = CGPathCreateMutable()
    var currentDrawing = SKShapeNode()
    let lineWidth:CGFloat = 4
    
    override func didMoveToView(view: SKView) {
        setupScene()
        setupGlobals()
        setupGestureRecognizers()
    }
       
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func setupScene() {
        self.backgroundColor = UIColor.whiteColor()
        self.physicsWorld.gravity = CGVectorMake(0, -9.8)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x:0, y:0, width:self.size.width, height:self.size.width))
    }
    
    func setupGlobals() {
        currentDrawing.strokeColor = UIColor.blackColor()
        currentDrawing.lineWidth = lineWidth
    }

    func setupGestureRecognizers() {
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target:self, action: Selector("handlePan:")))
    }
    
    func handlePan(panReco:UIPanGestureRecognizer) {
        let touchLoc = self.convertPointFromView(panReco.locationInView(panReco.view))
        
        if panReco.state == UIGestureRecognizerState.Began {
            CGPathMoveToPoint(currentPath, nil, touchLoc.x, touchLoc.y)
        
        } else if panReco.state == UIGestureRecognizerState.Changed {
            CGPathAddLineToPoint(currentPath, nil, touchLoc.x, touchLoc.y)
            
            adjustDrawing()
        
        } else if panReco.state == UIGestureRecognizerState.Ended {
            CGPathAddLineToPoint(currentPath, nil, touchLoc.x, touchLoc.y)
            CGPathCloseSubpath(currentPath)
        
            addObject()
            
            currentDrawing.removeFromParent()
            currentPath = CGPathCreateMutable()
        }
    }
    
    func adjustDrawing() {
        currentDrawing.removeFromParent()
        currentDrawing.path = currentPath
        self.addChild(currentDrawing)
    }
    
    func addObject() {
        let shapeNode = SKShapeNode(path: currentPath)
        shapeNode.strokeColor = getRandomColor()
        shapeNode.fillColor = getRandomColor()
        shapeNode.lineWidth = lineWidth
        
        self.addChild(shapeNode)
        let spriteNode = SKSpriteNode(texture: self.view.textureFromNode(shapeNode), size: shapeNode.frame.size)
        shapeNode.removeFromParent()
        
        spriteNode.position = CGPoint(x: shapeNode.frame.width/2, y: shapeNode.frame.height/2)
        spriteNode.physicsBody = SKPhysicsBody(texture: spriteNode.texture, alphaThreshold: 0.99, size: spriteNode.size)
        
        self.addChild(spriteNode)
    }
    
    func getRandomColor() -> UIColor {
        let hue = (CGFloat(arc4random() % 256)) / 256.0
        let saturation = ((CGFloat(arc4random() % 128)) / 256.0) + 0.5
        let brightness = ((CGFloat(arc4random() % 128)) / 256.0) + 0.5
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
}
