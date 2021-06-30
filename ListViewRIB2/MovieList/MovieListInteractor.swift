//
//  MovieListInteractor.swift
//  ListViewRIB
//
//  Created by Julio Reyes on 6/28/21.
//

import RIBs
import RxSwift
import RxCocoa

protocol MovieListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func showAlert(string: String)
    func attachMovieDetailRIB(movie: Movie)
    func detachMovieDetail()
}

protocol MovieListPresentableInput: AnyObject {
    var viewLoadTrigger: Observable<Void> { get }
    var refreshTrigger: Observable<Void> { get }

    var nextPageTrigger: Observable<Void> { get }
    var goDetailTrigger: Observable<Movie> { get }

}

protocol MovieListPresentableOutput: AnyObject {
    var list: BehaviorRelay<[Movie]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var isRefreshing: PublishRelay<Bool> { get }
}

protocol MovieListPresentable: Presentable {
    var listener: MovieListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    var input: MovieListPresentableInput? { get set }
    var output: MovieListPresentableOutput? { get set }
    
}

protocol MovieListListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MovieListInteractor: PresentableInteractor<MovieListPresentable>, MovieListInteractable, MovieListPresentableListener {

    weak var router: MovieListRouting?
    weak var listener: MovieListListener?
    
    private var page = 1
    private var disposeBag = DisposeBag()
    private let networkingAPI: APIClientService!
    
    // Relay initializers
    private let movieListRelay = BehaviorRelay<[Movie]>(value: [Movie]())
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let isRefreshingRelay = PublishRelay<Bool>()

    

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: MovieListPresentable, networkingAPI: APIClientService = APIClientService()) {
        
        self.networkingAPI = networkingAPI
        super.init(presenter: presenter)
        presenter.listener = self
        
        let activityIndicator = ActivityIndicator()
        let refreshIndicator = ActivityIndicator()
        
        guard let input = presenter.input else { return }
        
        input.viewLoadTrigger
            .asObservable()
            .flatMapLatest{
                networkingAPI.downloadSearchResultsForMovies(searchQuery: "The Matrix", forPage: self.page)
                    .trackActivity(activityIndicator)
                    .do(onError: { self.router?.showAlert(string: $0.localizedDescription) })
                    .catchAndReturn([])
            }
            .bind(to: self.movieListRelay)
            .disposed(by: disposeBag)
        
        
        input.refreshTrigger
            .asObservable()
            .map { self.page = 1 }
            .flatMapLatest{
                networkingAPI.downloadSearchResultsForMovies(searchQuery: "The Matrix", forPage: self.page)
                    .trackActivity(activityIndicator)
                    .do(onError: { self.router?.showAlert(string: $0.localizedDescription) })
                    .catchAndReturn([])
            }
            .bind(to: self.movieListRelay)
            .disposed(by: disposeBag)
        

    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
