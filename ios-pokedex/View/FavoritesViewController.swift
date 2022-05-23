//
//  FavoritesViewController.swift
//  ios-pokedex
//
//  Created by Gustavo Ziger on 18/05/22.
//

import UIKit

protocol FavoritesViewControllerDelegate: AnyObject {
    func didTapFavorite(_ pokemon: Pokemon)
}

class FavoritesViewController: UIViewController {

    var delegate: FavoritesViewControllerDelegate?
    
    private let tableView = UITableView()
    
    private var localPokemonList = [LocalPokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchLocalPokemons()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        configureUI()
        setConstraints()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func fetchLocalPokemons() {
        localPokemonList = DataManager.shared.retrieveLocalData()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localPokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon = localPokemonList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PokemonTableViewCell
        cell.delegate = self
        cell.configureCell(with: Pokemon(id: Int(pokemon.id), name: pokemon.name ?? "", types: pokemon.types ?? "", image: pokemon.image!, isFavorited: true))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let pokemon = localPokemonList[indexPath.row]
        let pokemonViewController = DetailsViewController()
        
        pokemonViewController.title = "Details: \(pokemon.name!.capitalized)"
        pokemonViewController.delegate = self
        pokemonViewController.configureView(with: Pokemon(id: Int(pokemon.id), name: pokemon.name!, types: pokemon.types!, image: pokemon.image!, isFavorited: true))
        
        navigationController?.pushViewController(pokemonViewController, animated: true)
    }
}

extension FavoritesViewController: PokemonTableViewCellDelegate, DetailsViewControllerDelegate {
    func didTapFavorite(_ pokemon: Pokemon) {
        self.delegate?.didTapFavorite(pokemon)
        fetchLocalPokemons()
    }
}
