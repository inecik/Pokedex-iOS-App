//
//  ViewController.swift
//  Pokedex
//
//  Created by Kemal İnecik on 15.07.2020.
//  Copyright © 2020 Kemal İnecik. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let pokemonCount = 151
    var pokemon: [Pokemon] = []
    var pokemonSearch: [Pokemon] = []

    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    // Searching Function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            pokemonSearch = pokemon
        }
        else {
            pokemonSearch.removeAll()
            for poke in pokemon {
                if poke.name.contains(searchText.lowercased()){
                    pokemonSearch.append(poke)
                }
            }
        }
        tableView.reloadData()
    }

    
    // Fetch the names of the pokemons
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(self.pokemonCount)")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                self.pokemon = pokemonList.results
                self.pokemonSearch = self.pokemon
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("\(error)")
            }
        }.resume()
    }
    
    
    // How many sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // How many rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonSearch.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Grab a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        // Change its text
        cell.textLabel?.text = pokemonSearch[indexPath.row].name.capitalized
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonSegue" {
            if let destination = segue.destination as? PokemonViewController {
                destination.pokemon = pokemonSearch[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
}
