//
//  APIEnvironment.swift
//  IMDBSearchMVVM
//
//  Created by Julio Reyes on 5/19/19. Updated on 9/16/19..
//  Copyright © 2019 Julio Reyes. All rights reserved.
//

import Foundation

enum Environment{
    case dev
    case test
    case prod
    
    func baseURL() -> String {
        return "\(urlAppProtocol())://\(urlIMDBDomain())/\(urlRoute())"
    }
    
    func baseURLforImage() -> String {
        return "\(urlAppProtocol())://\(urlIMDBImageDomain())"
    }
    
    func urlAppProtocol() -> String{
        switch self {
        case .prod:
            return "https"
        default:
            return "http"
        }
    }
    
    func urlIMDBDomain() -> String{

            return "api.themoviedb.org"

    }
    
    func urlIMDBImageDomain() -> String{

            return "image.tmdb.org/t/p"
    }
    
    func urlRoute() -> String{
        return "3"
    }
}

// In an actual application, this would the proper setup for my API environments
// But for the sake of expediency, the environment will run as if it were on Production
/*
#if DEBUG
let enviroment: Environment = .dev
#else
let enviroment: Environment = .prod
#endif
*/

let enviroment: Environment = .prod

let baseURL = enviroment.baseURL()
let baseImageURL = enviroment.baseURLforImage()

var baseSearchURL: String {
    return "\(baseURL)/search"
}
var movieSearch: String {
    return "\(baseSearchURL)/movie"
}

var imageURLforCompactSize: (String) -> String = { urlString in
    return "\(baseImageURL)/w600_and_h900_bestv2\(String(urlString))"
}
