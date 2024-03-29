//
//  SearchViewController.swift
//  iMusic
//
//  Created by Роман Гудков on 04.01.2023.
//  Copyright (c) 2023 Sibilus. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {

    let searchController = UISearchController(searchResultsController: nil)
  var interactor: SearchBusinessLogic?
  var router: (NSObjectProtocol & SearchRoutingLogic)?

    @IBOutlet weak var table: UITableView!
    
    private var searchViewModel = SearchViewModel.init(cells: [])
    private var timer: Timer?
    private lazy var footerView = FooterView()

  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = SearchInteractor()
    let presenter             = SearchPresenter()
    let router                = SearchRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
      setup()
      
      setupSearchBar()
      setupTableView()
  }
    private func setupSearchBar() {
        navigationItem.searchController = searchController;  navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    
        
    }
   
    private func setupTableView() {
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: TrackCell.reusId)
        table.tableFooterView = footerView
        
    }
    
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
      switch viewModel {
      case .displayTracks(let searchViewModel):
          print("viewController .displayTracks")
          self.searchViewModel = searchViewModel
          table.reloadData()
          footerView.hideLoader()
      case .displayFooterView:
          footerView.showLoader()
      }

  }
  
}
//MARK: -UITableViewDelegate, UITableViewDiffableDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: TrackCell.reusId, for: indexPath) as! TrackCell
        let cellViewModel = searchViewModel.cells[indexPath.row]
        cell.trackImageView.backgroundColor = .red
        cell.set(viewModel: cellViewModel)
        //print(cellViewModel.previewUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = searchViewModel.cells[indexPath.row]
        print("cellViewModel.trackName:", cellViewModel.trackName)
        
        // 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
        let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        let trackDetailsView = Bundle.main.loadNibNamed("TrackDetailView", owner: self, options: nil)?.first as! TrackDetailView
        window?.addSubview(trackDetailsView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter search term above.."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
         
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchViewModel.cells.count > 0 ? 0 : 250
    }
}
 
//MARK: -UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        searchController.obscuresBackgroundDuringPresentation = false
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_ ) in
            self.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchTerm: searchText))
        })
       
    }
}
