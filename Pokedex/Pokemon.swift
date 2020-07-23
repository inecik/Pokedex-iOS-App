//
//  Pokemon.swift
//  Pokedex
//
//  Created by Kemal İnecik on 15.07.2020.
//  Copyright © 2020 Kemal İnecik. All rights reserved.
//

import Foundation

struct PokemonList: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonData: Codable {
    let id: Int
    let types: [PokemonTypeEntry]
    let sprites: PokemonSpriteEntry
}

struct PokemonSpriteEntry: Codable {
    let front_default: String
    let back_default: String
}

struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

// For pokemon-species


struct PokemonSpecies: Codable {
    let flavor_text_entries: [PokemonFlavorTextEntry]
}

struct PokemonFlavorTextEntry: Codable {
    let flavor_text: String
    let version: PokemonFlavorTextEntryVersion
    let language: PokemonFlavorTextEntryLanguage
}

struct PokemonFlavorTextEntryVersion: Codable {
    let name: String
}

struct PokemonFlavorTextEntryLanguage: Codable {
    let name: String
}
