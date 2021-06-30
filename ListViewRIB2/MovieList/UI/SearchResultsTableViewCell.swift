//
//  SearchResultsTableViewCell.swift
//  IMDBSearchMVVM
//
//  Created by Julio Reyes on 5/19/19. Updated on 9/16/19..
//  Copyright © 2019 Julio Reyes. All rights reserved.
//

import Foundation
import UIKit

// Initialize the cache for the image.
let imageCache = NSCache<NSString, UIImage>()

class SearchResultsTableViewCell: UITableViewCell {
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieOverviewTextField: UITextView!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var movieScoreLabel: UILabel!
    
    
    var searchResults: Movie? {
        didSet {
            setPosterImageAndCache()
            setMovieScoreWithAttributedText()
            
            movieTitleLabel.text = String(searchResults?.title ?? "")
            movieOverviewTextField.text = String(searchResults?.overview ?? "N/A")
            releaseDateLabel.text = "Release Date: \(searchResults?.releaseDate ?? "N/A")"
        }
    }
    
    private func setPosterImageAndCache(){
        // Initialize the image view
        moviePosterImageView.image = nil
        // Cache image and initialize all variables
        self.imageActivityIndicator.startAnimating()
        
        // Download image from the poster path and cache the image for future use. If an image was already downloaded, it will use the image cached instead.
        if let imagePosterPath = searchResults?.posterPath {
            let imageFullURLString = imageURLforCompactSize(imagePosterPath)
            
            if let image = imageCache.object(forKey:imageFullURLString as NSString) {
                moviePosterImageView.image = image
                return
            }
            
            guard let requestImageURL = URL(string: imageFullURLString) else { return }
            
            URLSession.shared.dataTask(with: URLRequest(url: requestImageURL)) { (data, response, err) in
                guard let data = data, err == nil else {
                    return
                }
                
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    imageCache.setObject(image!, forKey: imageFullURLString as NSString)
                    self.moviePosterImageView.image = image
                    self.imageActivityIndicator.stopAnimating()
                }
                }.resume()
        }
    }
    
    private func setMovieScoreWithAttributedText(){
        let movieScoreAttributedText = NSMutableAttributedString(string: "\(searchResults?.voteAverage ?? 0) out of 10 ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        movieScoreAttributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, movieScoreAttributedText.string.count))
        
        let starAttachment = NSTextAttachment()
        starAttachment.image = UIImage(named: "starglyph")
        starAttachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
        movieScoreAttributedText.append(NSAttributedString(attachment: starAttachment))
        
        movieScoreLabel.attributedText = movieScoreAttributedText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
