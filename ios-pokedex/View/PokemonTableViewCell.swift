//
//  PokemonTableViewCell.swift
//  ios-pokedex
//
//  Created by Gustavo Ziger on 19/05/22.
//

import UIKit

protocol PokemonTableViewCellDelegate: AnyObject {
    func didTapFavorite(_ pokemon: Pokemon)
}

class PokemonTableViewCell: UITableViewCell {

    weak var delegate: PokemonTableViewCellDelegate?
    
    private var pokemon: Pokemon?
    private var pokemonName = UILabel()
    private var favoriteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(pokemonName)
        contentView.addSubview(favoriteButton)
        
        favoriteButton.addTarget(self, action: #selector(favorite), for: .touchUpInside)
        
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    private func setConstraints() {
        pokemonName.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        pokemonName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        pokemonName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        pokemonName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        
        favoriteButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        favoriteButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        favoriteButton.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
    }
    
    func configureCell(with pokemon: Pokemon) {
        pokemonName.text = pokemon.name.capitalized
        self.pokemon = pokemon
        
        if pokemon.isFavorited {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            favoriteButton.tintColor = .systemBlue
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            favoriteButton.tintColor = .lightGray
        }
    }
    
    @objc func favorite() {
        if let pokemon = pokemon {
            self.delegate?.didTapFavorite(pokemon)
        }
    }
}
