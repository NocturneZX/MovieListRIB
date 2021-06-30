//
//  MovieListRouter.swift
//  ListViewRIB
//
//  Created by Julio Reyes on 6/28/21.
//

import RIBs

protocol MovieListInteractable: Interactable {
    var router: MovieListRouting? { get set }
    var listener: MovieListListener? { get set }
}

protocol MovieListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MovieListRouter: ViewableRouter<MovieListInteractable, MovieListViewControllable>, MovieListRouting {
    func showAlert(string: String) {
        <#code#>
    }
    
    func attachMovieDetailRIB(movie: Movie) {
        <#code#>
    }
    
    func detachMovieDetail() {
        <#code#>
    }
    

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MovieListInteractable, viewController: MovieListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
