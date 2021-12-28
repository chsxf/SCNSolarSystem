//
//  ModelTools.swift
//  SCNSolarSystem
//
//  Created by Christophe SAUVEUR on 28/12/2021.
//

import Foundation
import SceneKit

class ModelTools {
    
    static func createSphere(withRadius radius: Float, lightingModel: SCNMaterial.LightingModel, texture: String, additionalTextures: AdditionalTexturesDescription? = nil) -> SCNNode {
        let material = SCNMaterial()
        material.diffuse.contents = texture
        material.lightingModel = lightingModel
        if additionalTextures?.normal != nil {
            material.normal.contents = additionalTextures!.normal!
        }
        if additionalTextures?.specular != nil {
            material.specular.contents = additionalTextures!.specular!
        }
        
        let sphere = SCNSphere(radius: CGFloat(radius))
        sphere.segmentCount = 48
        sphere.firstMaterial = material
        
        let node = SCNNode(geometry: sphere)
        return node
    }
    
    static func createRings(withInnerRadius innerRadius: Float, outerRadius: Float, texture: String) -> SCNNode {
        var vertices = [SCNVector3]()
        var normals = [SCNVector3]()
        var uvs = [CGPoint]()
        var indices = [Int32]()
        
        let segmentCount = 96
        
        let deg2Rad = Float.pi / 180
        let angleIncrement: Float = 360.0 / Float(segmentCount)
        let uvIncrement = 1.0 / Double(segmentCount)
        var index: Int32 = 0
        for i in 0...segmentCount {
            let angle = -angleIncrement * Float(i)
            let radAngle = angle * deg2Rad
            
            let cosinus = cos(radAngle)
            let sinus = sin(radAngle)
            
            let uvY = uvIncrement * Double(i)
            
            vertices.append(SCNVector3(cosinus * innerRadius, 0, sinus * innerRadius))
            normals.append(SCNVector3(0, -1, 0))
            uvs.append(CGPoint(x: 0.0, y: uvY))
            
            vertices.append(SCNVector3(cosinus * outerRadius, 0, sinus * outerRadius))
            normals.append(SCNVector3(0, -1, 0))
            uvs.append(CGPoint(x: 1.0, y: uvY))
            
            indices.append(index)
            indices.append(index + 1)
            index += 2
        }
        
        let verticesSource = SCNGeometrySource(vertices: vertices)
        let normalsSource = SCNGeometrySource(normals: normals)
        let uvsSource = SCNGeometrySource(textureCoordinates: uvs)
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangleStrip)
        
        let topMaterial = SCNMaterial()
        topMaterial.lightingModel = .blinn
        topMaterial.diffuse.contents = texture
        
        let bottomMaterial = SCNMaterial()
        bottomMaterial.lightingModel = .blinn
        bottomMaterial.diffuse.contents = texture
        bottomMaterial.cullMode = .front
        
        let geometry = SCNGeometry(sources: [verticesSource, normalsSource, uvsSource], elements: [element, element])
        geometry.materials = [topMaterial, bottomMaterial]
        
        let node = SCNNode(geometry: geometry)
        return node
    }
    
}
