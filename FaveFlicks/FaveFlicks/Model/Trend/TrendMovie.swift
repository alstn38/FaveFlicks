//
//  TrendMovie.swift
//  FaveFlicks
//
//  Created by 강민수 on 1/27/25.
//

import Foundation

struct TrendMovie: Codable {
    let page: Int
    let results: [DetailMovie]
}

// MARK: - Result
struct DetailMovie: Codable {
    let backdropPath: String?
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let genreIDArray: [Int]
    let releaseDate: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case genreIDArray = "genre_ids"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    func changeReleaseDate(_ dateString: String) -> DetailMovie {
        return DetailMovie(
            backdropPath: self.backdropPath,
            id: self.id,
            title: self.title,
            overview: self.overview,
            posterPath: self.posterPath,
            genreIDArray: self.genreIDArray,
            releaseDate: dateString,
            voteAverage: self.voteAverage
        )
    }
}
