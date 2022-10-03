//
//  MovieListViewController.swift
//  Movie-Library
//
//  Created by Sabbir Hossain on 27/9/22.
//

import UIKit

class MovieListViewController: UIViewController {

    @IBOutlet weak var tableViewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var movieListTableView: UITableView!
    var tableViewBottom : CGFloat = 0.0
    var viewModel = MovieListViewModel()
    var filteredMovies = [Movie]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
      return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupTableView()
        viewModel.gotMovieListAction = {
            DispatchQueue.main.async { [weak self] in
                self?.movieListTableView.reloadData()
            }
        }
        // Adding observer for handling keyboard
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil, queue: .main) { (notification) in
                                        self.handleKeyboard(notification: notification) }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                       object: nil, queue: .main) { (notification) in
                                        self.handleKeyboard(notification: notification) }
    }
    
    /// Handle KeyBoard
    /// - Parameter notification: Wiil Change Frame / hide
    func handleKeyboard(notification: Notification) {
        
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            tableViewBottomConst.constant = tableViewBottom
            view.layoutIfNeeded()
            return
        }
        
        guard
          let info = notification.userInfo,
          let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
          else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.tableViewBottomConst.constant = self.tableViewBottom + keyboardHeight
            self.view.layoutIfNeeded()
        })
    }
    
    /// Setup Search controller
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movie"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    /// Setup Table View
    private func setupTableView() {
        movieListTableView.delegate = self
        movieListTableView.dataSource = self
        movieListTableView.register(UINib(nibName: MovieInfoCell.className, bundle: nil), forCellReuseIdentifier: MovieInfoCell.className)
        movieListTableView.estimatedRowHeight = 110
        movieListTableView.rowHeight = UITableView.automaticDimension
        tableViewBottom = tableViewBottomConst.constant
    }
    
    /// Filter movie from movie list
    /// - Parameter searchText: text searched in search bar
    func filterMovies(searchText: String) {
        guard let movies = viewModel.movies else { return }
        filteredMovies = movies.filter { (movie: Movie) -> Bool in
            return movie.title?.lowercased().contains(searchText.lowercased()) ?? false
        }
        filteredMovies = movies.filter({ (movie:Movie) -> Bool in
            let titleMatch = movie.title?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let overviewMatch = movie.overview?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return titleMatch != nil || overviewMatch != nil }
        )
        
        movieListTableView.reloadData()
    }
        
}

//MARK: UITableViewDelegate & UITableViewDataSource methods

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredMovies.count : viewModel.movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MovieInfoCell = tableView.dequeueReusableCell(withIdentifier: MovieInfoCell.className, for: indexPath) as! MovieInfoCell
        guard let movies = viewModel.movies else { return cell }
        let movie = isFiltering ? filteredMovies[indexPath.row] : movies[indexPath.row]
        cell.configureCell(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: UISearchBarDelegate

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterMovies(searchText: text)
    }
}

