//
//  DataManager.swift
//  ios-pokedex
//
//  Created by Gustavo Ziger on 20/05/22.
//

import Foundation
import CoreData
import UIKit


class DataManager {
    
    static var shared = DataManager()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    Saves pokemons to coredata
    func saveLocal(with pokemon: Pokemon) {
        guard let entity = NSEntityDescription.entity(forEntityName: "LocalPokemon", in: context) else { return }
        
        let newLocalPokemon = NSManagedObject(entity: entity, insertInto: context)
        
        newLocalPokemon.setValue(pokemon.image, forKey: "image")
        newLocalPokemon.setValue(pokemon.id, forKey: "id")
        newLocalPokemon.setValue(pokemon.name, forKey: "name")
        newLocalPokemon.setValue(pokemon.types, forKey: "types")
                
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
//    Retrieves all pokemons from coredata
    func retrieveLocalData() -> [LocalPokemon] {
        var localPokemon = [LocalPokemon]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocalPokemon")
        
        do {
            let results = try context.fetch(fetchRequest)
            localPokemon = results as! [LocalPokemon]
        } catch {
            print(error)
        }
        
        return localPokemon
    }
    
//    Removes pokemon from coredata
    func removeLocal(with pokemon: Pokemon) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocalPokemon")
        
        do {
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [LocalPokemon] {
                if Int(result.id) == pokemon.id {
                    context.delete(result)
                    try context.save()
                }
            }
            
        } catch {
            print(error)
        }
    }
}
