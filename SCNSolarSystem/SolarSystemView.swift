//
//  SolarSystemView.swift
//  SCNSolarSystem
//
//  Created by Christophe SAUVEUR on 13/12/2021.
//

import SceneKit
import SpriteKit

class SolarSystemView: SCNView {
    
    override init(frame frameRect: NSRect, options: [String : Any]? = nil) {
        super.init(frame: frameRect, options: options)
        
        showsStatistics = true
        
        let scene = SCNScene()
        scene.background.contents = CGColor.black
        self.scene = scene
        
        let earthTexture = SKTexture(imageNamed: "Earth")
        let earthMaterial = SCNMaterial()
        earthMaterial.diffuse.contents = earthTexture
        
        let sphere = SCNSphere(radius: 1)
        sphere.firstMaterial = earthMaterial
        let sphereNode = SCNNode(geometry: sphere)
        scene.rootNode.addChildNode(sphereNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
