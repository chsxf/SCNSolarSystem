//
//  RotationComponent.swift
//  SCNSolarSystem
//
//  Created by Christophe on 26/12/2021.
//

import GameplayKit

#if os(macOS)
typealias FloatType = Double
#else
typealias FloatType = Float
#endif

class RotationComponent: GKSCNNodeComponent {
    
    let rotationPeriod: Float
    let radiansPerSecond: Double
    
    init(node: SCNNode, rotationPeriod: Float) {
        self.rotationPeriod = rotationPeriod
        radiansPerSecond = (Double.pi * 2) / Double(rotationPeriod)
        
        super.init(node: node)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        var rotation = node.eulerAngles
        rotation.y = rotation.y + FloatType(radiansPerSecond * seconds)
        node.eulerAngles = rotation
    }
    
}
