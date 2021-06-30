//
//  MovieListBuilder.swift
//  ListViewRIB
//
//  Created by Julio Reyes on 6/28/21.
//

import RIBs

protocol MovieListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MovieListComponent: Component<MovieListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    let movieListController: MovieListViewController
    
    init(dependency: MovieListDependency, rootViewController: MovieListViewController) {
        self.movieListController = rootViewController
        super.init(dependency: dependency)
    }
    
}

// MARK: - Builder

protocol MovieListBuildable: Buildable {
    func build(withListener listener: MovieListListener) -> MovieListRouting
}

final class MovieListBuilder: Builder<MovieListDependency>, MovieListBuildable {

    override init(dependency: MovieListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MovieListListener) -> MovieListRouting {
        let viewController = MovieListViewController()
        let component = MovieListComponent(dependency: dependency, rootViewController: viewController)
        let interactor = MovieListInteractor(presenter: viewController)
        interactor.listener = listener
        return MovieListRouter(interactor: interactor, viewController: viewController)
    }
}
