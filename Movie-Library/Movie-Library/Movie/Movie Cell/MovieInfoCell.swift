//
//  MovieInfoCell.swift
//  Movie-Library
//
//  Created by Sabbir Hossain on 27/9/22.
//

import UIKit

class MovieInfoCell: UITableViewCell {

    @IBOutlet weak var posterImageVIew: UIImageView!
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
    
    func configureCell(movie: Movie) {
        self.titleLabel.text = movie.title
        self.overviewLabel.text = movie.overview
        let posterImageUrlString = MovieListViewModel.posterImageBaseUrl + movie.posterPath
        let url = URL(string: posterImageUrlString)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async { [weak self] in
                if let data = data {
                    self?.posterImageVIew.image = UIImage(data: data)
                }
            }
        }
    }
}
