//
//  PokemonRepository.swift
//  ios-pokedex
//
//  Created by Gustavo Ziger on 21/05/22.
//

import Foundation


class PokemonRepository {
    
    private var pokemonList = [Pokemon]()
    private var localPokemonList: [LocalPokemon]
    
    init() {
        localPokemonList = DataManager.shared.retrieveLocalData()
    }
    
    func loadPokemonData() async -> [Pokemon] {
//      Gets raw pokemon list with name and url
        let resultList = await NetworkManager.shared.getPokemonList()
        
        for entry in resultList {
//          Gets detailed information about the pokemon
            let pokemonResponse = await NetworkManager.shared.getPokemonDetail(from: entry.url)
            
            if let pokemonResponse = pokemonResponse {
                
//              Gets image data, creates Pokemon object and then appends to the list
                let pokemonImage = await NetworkManager.shared.getImageData(from: pokemonResponse.sprites.front_default)
                
                var pokemon = Pokemon(id: pokemonResponse.id, name: pokemonResponse.name, types: pokemonResponse.types.map { $0.type.name }.joined(separator: ", "), image: pokemonImage, isFavorited: false)

//              Marks as favorite if register on local database was found
                if (self.localPokemonList.firstIndex { Int($0.id) == pokemonResponse.id }) != nil {
                    pokemon.isFavorited = true
                }

                self.pokemonList.append(pokemon)
            }
        }
        
        return self.pokemonList
    }
    
    func loadLocalData() -> [LocalPokemon] {
        return self.localPokemonList
    }
    
    func loadData() -> [Pokemon] {
        return self.pokemonList
    }
    
    func favoritePokemon(_ pokemon: Pokemon) {
        if pokemon.isFavorited {
            localPokemonList.remove(at: localPokemonList.firstIndex { Int($0.id) == pokemon.id }!)
            pokemonList[pokemonList.firstIndex { $0.id == pokemon.id }!].isFavorited = false
            DataManager.shared.removeLocal(with: pokemon)
        } else {
            DataManager.shared.saveLocal(with: pokemon)
            self.localPokemonList = DataManager.shared.retrieveLocalData()
            pokemonList[pokemonList.firstIndex { $0.id == pokemon.id }!].isFavorited = true
        }
    }
}
