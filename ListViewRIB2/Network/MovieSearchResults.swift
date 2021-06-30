//
//  MovieSearchResults.swift
//  IMDBSearchMVVM
//
//  Created by Julio Reyes on 5/18/19. Updated on 9/16/19..
//  Copyright © 2019 Julio Reyes. All rights reserved.
//
import Foundation


typealias ListOfMovies = [Movie]
// MARK: - MovieSearchResults Base
struct MovieSearchResults: Codable {
    let page, totalResults, totalPages: Int
    let results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct Movie: Codable {
    let voteCount, id: Int?
    let video: Bool?
    let voteAverage: Double?
    let title: String?
    let popularity: Double?
    let posterPath: String?
    let originalLanguage: String?
    let originalTitle: String
    let genreIDS: [Int]?
    let backdropPath: String?
    let adult: Bool?
    let overview, releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id, video
        case voteAverage = "vote_average"
        case title, popularity
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case backdropPath = "backdrop_path"
        case adult, overview
        case releaseDate = "release_date"
    }
}


//enum OriginalLanguage: String, Codable {
//    case en = "en"
//    case fr = "fr"
//    case de = "de"
//}
