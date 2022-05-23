//
//  PokemonInfoViewController.swift
//  ios-pokedex
//
//  Created by Gustavo Ziger on 18/05/22.
//

import UIKit

protocol DetailsViewControllerDelegate: AnyObject {
    func didTapFavorite(_ pokemon: Pokemon)
}

class DetailsViewController: UIViewController {
    
    weak var delegate: DetailsViewControllerDelegate?
    
    private let pokemonId = UILabel()
    private let pokemonName = UILabel()
    private let pokemonType = UILabel()
    private let pokemonImage = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(pokemonImage)
        view.addSubview(pokemonId)
        view.addSubview(pokemonName)
        view.addSubview(pokemonType)
        
        setConstraints()
    }
    
    private func setConstraints() {
        pokemonImage.translatesAutoresizingMaskIntoConstraints = false
        pokemonId.translatesAutoresizingMaskIntoConstraints = false
        pokemonName.translatesAutoresizingMaskIntoConstraints = false
        pokemonType.translatesAutoresizingMaskIntoConstraints = false
        
        pokemonImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        pokemonImage.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 50).isActive = true
        pokemonImage.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -50).isActive = true
        pokemonImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        pokemonImage.contentMode = .scaleAspectFit
        
        pokemonId.topAnchor.constraint(equalTo: pokemonImage.bottomAnchor, constant: 10).isActive = true
        pokemonId.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 50).isActive = true
        pokemonId.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 50).isActive = true
        
        pokemonName.topAnchor.constraint(equalTo: pokemonId.bottomAnchor, constant: 10).isActive = true
        pokemonName.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 50).isActive = true
        pokemonName.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -50).isActive = true
        
        pokemonType.topAnchor.constraint(equalTo: pokemonName.bottomAnchor, constant: 10).isActive = true
        pokemonType.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 50).isActive = true
        pokemonType.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -50).isActive = true
    }
    
    func configureView(with pokemon: Pokemon) {
        var pokemon = pokemon
        
//      Use of ternary expressions to define button appearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: pokemon.isFavorited ? "Unfavorite" : "Favorite",
            image: pokemon.isFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"),
            primaryAction: UIAction(
                title: pokemon.isFavorited ? "Unfavorite" : "Favorite",
                handler: {_ in
                    self.delegate?.didTapFavorite(pokemon)
                    pokemon.isFavorited = !pokemon.isFavorited
                    self.navigationItem.rightBarButtonItem?.image = pokemon.isFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
                }
            )
        )
        
        DispatchQueue.main.async {
            self.pokemonImage.image = UIImage(data: pokemon.image)

            let boldAttribute = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)]

            let boldID = NSMutableAttributedString(string: "ID: ", attributes: boldAttribute)
            boldID.append(NSMutableAttributedString(string: String(pokemon.id)))
            self.pokemonId.attributedText = boldID
            
            let boldName = NSMutableAttributedString(string: "Name: ", attributes: boldAttribute)
            boldName.append(NSMutableAttributedString(string: pokemon.name.capitalized))
            self.pokemonName.attributedText = boldName
            
            let boldType = NSMutableAttributedString(string: "Type: ", attributes: boldAttribute)
            boldType.append(NSMutableAttributedString(string: pokemon.types))
            self.pokemonType.attributedText = boldType
        }
    }
}
