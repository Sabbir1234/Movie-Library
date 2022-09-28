//
//  MovieInfoCell.swift
//  Movie-Library
//
//  Created by Sabbir Hossain on 27/9/22.
//

import UIKit

class MovieInfoCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /// Configuring Cell with movie value
    /// - Parameter movie: Struct ( Movie )
    func configureCell(movie: Movie) {
        self.titleLabel.text = movie.title
        self.overviewLabel.text = movie.overview
        let posterImageUrlString = MovieListViewModel.posterImageBaseUrl + movie.posterPath
        let url = URL(string: posterImageUrlString)
        
        // retrieves image if already available in cache
        if let imageFromCache = MovieListViewModel.imageCache.object(forKey: url as AnyObject) as? UIImage {
            posterImageView.image = imageFromCache
        } else {
            // Getting image from remote URL in Background thread
            DispatchQueue.global().async {
                
                guard let url = url else {
                    self.posterImageView.image = UIImage(named: "NoImageIcon")
                    return
                }
                
                let data = try? Data(contentsOf: url)
                // Setting image in main thread
                DispatchQueue.main.async { [weak self] in
                    if let data = data {
                        self?.posterImageView.image = UIImage(data: data)
                        // Caching image
                        if let image = UIImage(data: data) {
                            MovieListViewModel.imageCache.setObject(image, forKey: url as AnyObject)
                        }
                    } else {
                        self?.posterImageView.image = UIImage(named: "NoImageIcon")
                    }
                }
            }
        }
    }
}
