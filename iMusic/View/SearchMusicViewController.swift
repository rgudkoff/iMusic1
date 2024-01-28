//
//  SearchViewController.swift
//  iMusic
//
//  Created by Роман Гудков on 04.01.2023.
//

import UIKit
import Alamofire

struct TrackModel{
    var trackName: String
    var artistName: String
}

class SearchMusicViewController:  UITableViewController{

    var networkService = NetworkService()
    let searchController = UISearchController(searchResultsController: nil)
    var trackArray = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = . white
        setupSearchBar()

        
        tableView.register(UITableViewCell.self , forCellReuseIdentifier: "cellId")
        
         
    }
    private var timer: Timer?
    private func setupSearchBar() {
        navigationItem.searchController = searchController;  navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  "cellId", for: indexPath)
        let track = trackArray[indexPath.row]
        cell.textLabel?.text = " \(track.trackName)\n\(track.artistName )"
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = #imageLiteral(resourceName: "library - Selcted")
        return cell
    }
    
}

extension SearchMusicViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
                self.networkService.fetchTracks(searchText: searchText) { [weak self] (searchResults) in
                    self?.trackArray = searchResults?.results ?? []
                    self?.tableView.reloadData()
                }

            })
            
        }
}
