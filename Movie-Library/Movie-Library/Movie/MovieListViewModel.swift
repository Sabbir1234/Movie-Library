//
//  MovieListViewModel.swift
//  Movie-Library
//
//  Created by Sabbir Hossain on 27/9/22.
//

import Foundation

class MovieListViewModel {
    var movies : [Movie]?
    let baseUrl = "https://api.themoviedb.org/3/search/movie?api_key=be848c19400f09684af473cde6176a48&query=marvel"
    static let posterImageBaseUrl = "http://image.tmdb.org/t/p/w500"
    var gotMovieListAction: (() -> Void)?
    
    func getMovies() {
        guard let url = URL(string: baseUrl) else { return }
        MovieFinder.fetchData(at: url) { (result: Result<Movies, Error>) in
            switch result {
            case .success(let movies):
                self.movies = movies.results
                self.gotMovieListAction?()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}
