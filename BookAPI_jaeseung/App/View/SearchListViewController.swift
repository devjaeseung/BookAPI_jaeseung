//
//  ViewController.swift
//  BookAPI_jaeseung
//
//  Created by jaeseung lim on 2022/08/11.
//

import UIKit
import Kingfisher
import SnapKit

class SearchListViewController: UIViewController {

    let TAG = "SearchListViewController"
    
    private let viewModel: SearchListViewModel
    private var data : [SearchItemModel]?
    private var totalItem : Int?
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    var previousIndex = 0
    
    init(viewModel: SearchListViewModel) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(TAG," viewDidLoad ")
        // Do any additional setup after loading the view.
        //view.backgroundColor = .lightGray
        // Search Bar에서 검색시 dimmed 되는 현상
        definesPresentationContext = true
        
        navigationItem.title = "Google Book Store"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // SearchController 설정
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        tableView.tableHeaderView = searchController.searchBar
        
        
        // tableView Layout 설정
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.register(SearchListTableViewCell.self, forCellReuseIdentifier: SearchListTableViewCell.identifier)
        tableView.register(SearchListSectionHeader.self, forHeaderFooterViewReuseIdentifier: SearchListSectionHeader.identifier)
        
        tableView.rowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(TAG," viewWillAppear ")
        //viewModel.ready()
    }
    
    private func setupViewModel(){
        print(TAG," setupViewModel ")

        
        viewModel.didUpdateSearhList = { [weak self] items in
            
            guard let strongSelf = self else { return }
            print(strongSelf.TAG," didUpdateSearhList 시작")
            
            strongSelf.data = items
            strongSelf.tableView.reloadData()
            
        }
        
        viewModel.totalItemCount = { [weak self] totalcount in
            
            guard let strongSelf = self else { return }
            
            print(strongSelf.TAG," totalItemCount : \(totalcount)")
            strongSelf.totalItem = totalcount
            strongSelf.tableView.reloadSectionIndexTitles()

        }
        

        
    }

}

extension SearchListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(TAG," tableView numberOfRowsInSection data.count: \(data?.count ?? 0)")
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchListTableViewCell.identifier) as! SearchListTableViewCell
        
        print(TAG," tableView cellForRowAt data?[\(indexPath.row)] : \(data?[indexPath.row])")
        
        
        cell.titleLabel.text = data?[indexPath.row].title
        let authorsStringArray = data?[indexPath.row].authors
        //print(TAG,"cellForRowAt - authorsString : \(authorsStringArray)")
        let authorsString = authorsStringArray?.joined(separator:",")
        cell.authorLabel.text = authorsString
        cell.dateLabel.text = data?[indexPath.row].date
        let imageUrlString = data?[indexPath.row].tumbnail
        cell.bookImageView.kf.setImage(with: URL(string:imageUrlString ?? ""))
        
        return cell
    }
    
}

extension SearchListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt : \(indexPath)")
        
        let model = data?[indexPath.row]
        
        let webVC = WebViewController(searchItemModel: model!)
        
        self.navigationController?.pushViewController(webVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let searchListSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchListSectionHeader.identifier) as? SearchListSectionHeader else {
            return UIView()
        }
        
        searchListSectionHeader.resultcountLabel.text = "Results (\(totalItem ?? 0))"
        
        return searchListSectionHeader
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let datacount = data?.count ?? 0
        
        if datacount > 0 && indexPath.row == (datacount - 1) {
            previousIndex += 9
            viewModel.pagenation(query: searchController.searchBar.text ?? "" ,startIndex: previousIndex)
            
            
        }
        
        
    }
    
}

extension SearchListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("searchController : \(searchController)")
        viewModel.didChangeQuery(searchController.searchBar.text ?? "")
    }
    
}

