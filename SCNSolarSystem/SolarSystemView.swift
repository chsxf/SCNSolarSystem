//
//  SolarSystemView.swift
//  SCNSolarSystem
//
//  Created by Christophe SAUVEUR on 13/12/2021.
//

import SceneKit
import GameplayKit

class SolarSystemView: SCNView, SCNSceneRendererDelegate {
    
    private var lastTime: TimeInterval?
    
    private var entities = [GKEntity]()
    
    override init(frame frameRect: NSRect, options: [String : Any]? = nil) {
        super.init(frame: frameRect, options: options)
        
        delegate = self
        
        showsStatistics = true
        allowsCameraControl = true
        rendersContinuously = true
        preferredFramesPerSecond = 30
        
        let description: SolarSystemDescription = Functions.load("data.json")
        
        let scene = SCNScene()
        self.scene = scene

        scene.background.contents = description.backgroundTexture
        
        let sun = ModelTools.createSphere(withRadius: description.sun.engineRadius, lightingModel: .constant, texture: description.sun.texture)
        sun.name = "Sun"
        scene.rootNode.addChildNode(sun)
        
        let sunEntity = GKEntity()
        let sunComponent = RotationComponent(node: sun, rotationPeriod: description.sun.engineRotationPeriod)
        sunEntity.addComponent(sunComponent)
        entities.append(sunEntity)
        
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.name = "Sun Light"
        lightNode.light = light
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 20
        let ambientLightNode = SCNNode()
        ambientLightNode.name = "Ambient Space Light"
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)
        
        for stellarObject in description.stellarObjects {
            let node = ModelTools.createSphere(withRadius: stellarObject.engineRadius, lightingModel: .blinn, texture: stellarObject.texture, additionalTextures: stellarObject.additionalTextures)
            node.position = SCNVector3(stellarObject.enginePerihelion, 0, 0)
            node.name = stellarObject.name
            scene.rootNode.addChildNode(node)
            
            let planetEntity = GKEntity()
            let planetComponent = RotationComponent(node: node, rotationPeriod: stellarObject.engineRotationPeriod)
            planetEntity.addComponent(planetComponent)
            entities.append(planetEntity)
            
            if stellarObject.rings != nil {
                let ringsNode = ModelTools.createRings(withInnerRadius: stellarObject.rings!.engineInnerRadius, outerRadius: stellarObject.rings!.engineOuterRadius, texture: stellarObject.rings!.texture)
                node.addChildNode(ringsNode)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let lastTime = lastTime else {
            lastTime = time
            return
        }

        let diff = time - lastTime
        self.lastTime = time

        for entity in entities {
            entity.update(deltaTime: diff)
        }
    }
    
}
