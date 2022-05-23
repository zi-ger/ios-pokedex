//
//  PokemonResults.swift
//  ios-pokedex
//
//  Created by Gustavo Ziger on 21/05/22.
//

import Foundation


// Structs used to parse the first api call

struct PokemonResultsEntry: Codable {
    var name: String
    var url: String
}

struct PokemonResults: Codable {
    var results: [PokemonResultsEntry]
}

