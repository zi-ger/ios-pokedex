//
//  NetworkManager.swift
//  ios-pokedex
//
//  Created by Gustavo Ziger on 19/05/22.
//

import Foundation
import Network


class NetworkManager {

    static let shared = NetworkManager()

    private let decoder = JSONDecoder()

    private let apiURL = "https://pokeapi.co/api/v2/pokemon?limit=100&offset=0"


//    Return raw pokemon list from api
    func getPokemonList() async -> [PokemonResultsEntry] {
        guard let url = URL(string: apiURL) else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let pokemonList = try self.decoder.decode(PokemonResults.self, from: data)
            
            return pokemonList.results
        } catch {
            print(error)
            return []
        }
    }

//    Returns Pokemon Response object from url
    func getPokemonDetail(from url:String) async -> PokemonResponse? {
        guard let url = URL(string: url) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let pokemonDetails = try self.decoder.decode(PokemonResponse.self, from: data)
            
            return pokemonDetails
        } catch {
            print(error)
            return nil
        }
    }

//    Returs pokemon image data from url
    func getImageData(from url: String) async -> Data {
        guard let url = URL(string: url) else { return Data() }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            return data
        } catch {
            print(error)
            return Data()
        }
    }

}
