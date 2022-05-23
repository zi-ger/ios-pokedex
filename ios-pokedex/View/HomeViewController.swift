//
//  ViewController.swift
//  ios-pokedex
//
//  Created by Gustavo Ziger on 18/05/22.
//

import UIKit


class HomeViewController: UIViewController {
    
    private var pokemonRepository = PokemonRepository()
    private var pokemonList = [Pokemon]()
    
    let tableView = UITableView()
    
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        configureTableView()
        configureActivityIndicator()
        fetchPokemons()
    }

    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Pokedex"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(showFavorites))
    }
    
    private func configureActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .darkGray
        activityIndicator.tintColor = .black
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc func showFavorites() {
        let favoritesViewController = FavoritesViewController()
        favoritesViewController.title = "Favorites"
        favoritesViewController.delegate = self
        navigationController?.pushViewController(favoritesViewController, animated: true)
    }
    
    private func fetchPokemons() {
        Task {
            activityIndicator.startAnimating()
            self.pokemonList = await pokemonRepository.loadPokemonData()
            self.tableView.reloadData()
            activityIndicator.stopAnimating()
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pokemon = pokemonList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PokemonTableViewCell
        cell.delegate = self
        cell.configureCell(with: pokemon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let pokemon = pokemonList[indexPath.row]
        
        let pokemonViewController = DetailsViewController()
        pokemonViewController.title = "Details: \(pokemon.name.capitalized)"
        pokemonViewController.delegate = self
        pokemonViewController.configureView(with: pokemon)
        
        navigationController?.pushViewController(pokemonViewController, animated: true)
    }
}

extension HomeViewController: PokemonTableViewCellDelegate, DetailsViewControllerDelegate, FavoritesViewControllerDelegate {
    func didTapFavorite(_ pokemon: Pokemon) {
        
        pokemonRepository.favoritePokemon(pokemon)
        
        DispatchQueue.main.async {
            self.pokemonList = self.pokemonRepository.loadData()
            self.tableView.reloadData()
        }
    }
}
