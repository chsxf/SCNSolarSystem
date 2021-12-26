//
//  SolarSystemDescription.swift
//  SCNSolarSystem
//
//  Created by Christophe on 26/12/2021.
//

import Foundation

struct SunDescription: Codable {
    let texture: String
    let radius: Float
}

struct AdditionalTexturesDescription: Codable {
    let normal: String?
    let specular: String?
}

struct StellarObjectDescription: Codable {
    let name: String
    let texture: String
    let additionalTextures: AdditionalTexturesDescription?
    let radius: Float
    let distanceFromSun: Float
}

struct SolarSystemDescription: Codable {
    let backgroundTexture: String
    let sun: SunDescription
    let stellarObjects: [StellarObjectDescription]
}
