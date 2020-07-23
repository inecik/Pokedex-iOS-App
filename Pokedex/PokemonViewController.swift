//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Kemal İnecik on 15.07.2020.
//  Copyright © 2020 Kemal İnecik. All rights reserved.
//

import UIKit
import Foundation

class PokemonViewController: UIViewController {
    
    var pokemon: Pokemon!
    var pokemonInOrOut: String?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet weak var catchButtonText: UIButton!
    @IBAction func catchButtonEvent(_ sender: UIButton) {
        if pokemonInOrOut == nil || pokemonInOrOut == "Released" {
            catchButtonText.setTitle("Release", for: .normal)
            UserDefaults.standard.set("Catched", forKey: pokemon.name)
        }
        else {
            catchButtonText.setTitle("Catch", for: .normal)
            UserDefaults.standard.set("Released", forKey: pokemon.name)
        }
        UserDefaults.standard.synchronize()
    }
    
    @IBOutlet weak var sprite: UIImageView!
    @IBOutlet weak var information: UILabel!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = "-"
        type2Label.text = "-"
        information.text = ""
        
        
        pokemonInOrOut = UserDefaults.standard.string(forKey: pokemon.name)
        if pokemonInOrOut == nil || pokemonInOrOut == "Released" {
            catchButtonText.setTitle("Catch", for: .normal)
        } else if pokemonInOrOut == "Catched" {
            catchButtonText.setTitle("Release", for: .normal)
        }
        
        
        let url = URL(string: pokemon.url)
        guard let u = url else {
            return
        }
        URLSession.shared.dataTask(with: u) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                
                DispatchQueue.main.async {
                    
                    // PokemonURL
                    self.nameLabel.text = self.pokemon.name.capitalized
                    self.numberLabel.text = String(format: "#%03d", pokemonData.id)
                    for typeEntry in pokemonData.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name.capitalized
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name.capitalized
                        }
                    }
                    
                    // Image
                    do {
                        let url_image = URL(string: pokemonData.sprites.front_default)
                        let image_data: Data = try Data(contentsOf: url_image!)
                        self.sprite.image = UIImage(data: image_data)
                    } catch let error {
                        print("\(error)")
                    }
                
                } // End ofDispatchQueue
                
            } catch let error {
                print("\(error)")
            }
        }.resume()
        
        
        let pokemon_id = pokemon.url.split(separator: "/").last!
        let url_info = URL(string: "https://pokeapi.co/api/v2/pokemon-species/" + pokemon_id)
        guard let url_info_guarded = url_info else {
            return
        }
        URLSession.shared.dataTask(with: url_info_guarded) { (data, response, error) in
            guard let data = data else {
                return
            }
            var to_put_info: String = "-"
            do {
                let pokemonSpecies = try JSONDecoder().decode(PokemonSpecies.self, from: data)
    
                DispatchQueue.main.async {
                    for entry in pokemonSpecies.flavor_text_entries {
                        if (entry.version.name == "gold" && entry.language.name == "en") {
                            to_put_info = entry.flavor_text.replacingOccurrences(of: "\n", with: " ")
                            to_put_info = to_put_info.replacingOccurrences(of: "\u{0C}", with: " ")
                            self.information.text = to_put_info
                        }
                    }
                } // End of DispatchQueue
                        
            } catch let error {
                self.information.text = "Undefined"
                print("\(error)")
            }
        }.resume()
    }
}
