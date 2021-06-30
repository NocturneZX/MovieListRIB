//
//  MovieListViewController.swift
//  ListViewRIB
//
//  Created by Julio Reyes on 6/28/21.
//

import RIBs
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources


protocol MovieListPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MovieListViewController: UIViewController, MovieListPresentable, MovieListViewControllable {

    weak var listener: MovieListPresentableListener?
    
    private let tableView = UITableView()
      private let refreshControl = UIRefreshControl()
      private let activityIndicator = UIActivityIndicatorView(style: .large)
      private let disposeBag = DisposeBag()
      var input: MovieListPresentableInput?
      var output: MovieListPresentableOutput?
      
      // MARK: - Table View
      
      private let dataSource = RxTableViewSectionedReloadDataSource<MovieListSection>(configureCell: {  (_, tableView, _, movies) -> UITableViewCell in
          let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsCellIdentifier") as? SearchResultsTableViewCell ?? SearchResultsTableViewCell(style: .default, reuseIdentifier: "SearchResultsCellIdentifier")
          cell.searchResults = movies
          return cell
      })
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        input = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        setupNavigationTitle()
        self.bindOutput()
    }
    
    
    // MARK: - Private Methods
    
    private func setupSubview() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        tableView.addSubview(refreshControl)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupNavigationTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Movies"
        self.navigationItem.accessibilityLabel = "MoviesList"
    }
    
    func pushViewController(_ viewController: ViewControllable, animated: Bool) {
        viewController.uiviewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController.uiviewController, animated: animated)
    }
    
    func popViewController(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
}

extension MovieListViewController: MovieListPresentableInput {
    var viewLoadTrigger: Observable<Void> {
        return self.rx.viewDidLoad.asObservable()
    }
    
    var refreshTrigger: Observable<Void> {
        return refreshControl.rx.controlEvent(.valueChanged).asObservable()
    }
    
    var nextPageTrigger: Observable<Void> {
        return tableView.rx.reachedBottom(offset: 120.0).asObservable()
    }
    
    var goDetailTrigger: Observable<Movie> {
        return tableView.rx.modelSelected(Movie.self).asObservable()
    }
}


extension MovieListViewController {
    
    private func bindOutput() {
        guard let output = output else { return }
        
        output.list
            .map { [MovieListSection(header: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.isRefreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { self.tableView.deselectRow(at: $0, animated: true)})
            .disposed(by: disposeBag)
        
    }
}
