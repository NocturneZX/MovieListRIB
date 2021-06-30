//
//  APIClientService.swift
//  IMDBSearchMVVM
//
//  Created by Julio Reyes on 5/18/19. Updated on 9/16/19..
//  Copyright © 2019 Julio Reyes. All rights reserved.
//

import Foundation
import RxSwift
typealias MovieDataRetrievalComplete = (_ results:MovieSearchResults?, Error?) -> ()


// With the introduction to Swift 4, we are now given more customization to parsing JSON. I decided to use the JSONDecoder for it makes it easier for me to define the properties that the JSON file gives to it. More customization and removes the clutter from the data structures' composition of the NSCoding protocol and traditional JSON parsing (If you parsed JSON between 2012-2015 in Obj-C, you understand). Also, making the data structure Codable would allow me to save the data off-line with the NSKeyedArchiver.
fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}


struct APIClientService {
    
    //guard let queryCheck = artist.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
      //  return nil
    //}
    
    func downloadSearchResultsForMovies<T: Codable>(searchQuery: String, forPage: Int) -> Observable<T>{
        
        var urlComponents = URLComponents(string: movieSearch)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: "2a61185ef6a27f400fd92820ad9e8537"),
                           URLQueryItem(name: "query", value: searchQuery),
                           URLQueryItem(name: "page", value: String(forPage))]
        
        let fullURL: URL = urlComponents!.url!
        
        var searchRequest = URLRequest(url: fullURL,
                                       cachePolicy: .useProtocolCachePolicy,
                                       timeoutInterval: 10.0)
        searchRequest.httpMethod = "GET"
        
        print(urlComponents?.string ?? "None")
        
        return URLSession.shared.rx.data(request: searchRequest)
            .subscribe(on: SerialDispatchQueueScheduler(qos: .utility))
            .map { data in try JSONDecoder().decode(MovieSearchResults.self, from: data) as! T }

        
//        let task = URLSession.shared.dataTask(with: searchRequest, completionHandler: { (data: Data?,
//            response: URLResponse?, error: Error?) in
//            guard let _ = response as? HTTPURLResponse, let data = data else {
//                print("API response error")
//                complete(nil, error?.localizedDescription as? Error)
//                return
//            }
//
//            // Parse the data
//            let searchResults = try! newJSONDecoder().decode(MovieSearchResults.self, from: data)
//            complete (searchResults, error?.localizedDescription as? Error)
//
//        })
//
//        task.resume()
    }
}
