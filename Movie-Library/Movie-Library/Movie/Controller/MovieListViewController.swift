//
//  MovieListViewController.swift
//  Movie-Library
//
//  Created by Sabbir Hossain on 27/9/22.
//

import UIKit

class MovieListViewController: UIViewController {

    @IBOutlet weak var movieListTableView: UITableView!
    var viewModel = MovieListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.getMovies()
        viewModel.gotMovieListAction = {
            DispatchQueue.main.async { [weak self] in
                self?.movieListTableView.reloadData()
            }
        }
    }
    
    /// Setup Table View
    private func setupTableView() {
        movieListTableView.delegate = self
        movieListTableView.dataSource = self
        movieListTableView.register(UINib(nibName: MovieInfoCell.className, bundle: nil), forCellReuseIdentifier: MovieInfoCell.className)
        movieListTableView.estimatedRowHeight = 110
        movieListTableView.rowHeight = UITableView.automaticDimension
    }
}

//MARK: UITableViewDelegate & UITableViewDataSource methods

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MovieInfoCell = tableView.dequeueReusableCell(withIdentifier: MovieInfoCell.className, for: indexPath) as! MovieInfoCell
        guard let movies = viewModel.movies else { return cell }
        cell.configureCell(movie: movies[indexPath.row])
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
