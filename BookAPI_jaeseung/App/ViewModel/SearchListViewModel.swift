//
//  SearchListViewModel.swift
//  BookAPI_jaeseung
//
//  Created by jaeseung lim on 2022/08/12.
//

import Foundation

final class SearchListViewModel {
    
    let TAG = "SearchListViewModel"
    
    // Outputs
    var isRefreshing: ((Bool) -> Void)?
    var didUpdateSearhList: (([SearchItemModel]) -> Void)?

    var totalItemCount: ((Int) -> Void)?
    
    
    // DataBinding
    private(set) var items: [volumeInfoModel] = [volumeInfoModel]() {
        
        didSet {
            print(TAG," items 변수 할당 시작")
            didUpdateSearhList?(items.map {
                print(TAG," didUpdateSearhList 클로저 작동")
                print(TAG," items.map 변수 할당 $0: \($0)")
                
                return SearchItemModel(volumeInfoModel: $0)
                
            })
        }
        
    }
    
    private(set) var totalItem: Int = Int() {
        
        didSet {
            totalItemCount?(totalItem)
        }
        
    }
    
    private let throttle = Throttle(minimumDelay: 0.3)
    // 현재 URLSessionDataTask 확인
    private var currentSearchNetworkTask: URLSessionDataTask?
    // 마지막으로 검색했던 단어
    private var lastQuery: String?
    
    // Dependencies
    private let networkingService: NetworkingService
    
    init(networkingService: NetworkingService){
        print(TAG,"SearchListViewModel - init 함수 - networkingService객체 : \(networkingService)")
        self.networkingService = networkingService
    }
    
    //Inputs
    func ready(){
        print(TAG,"SearchListViewModel - ready함수 시작")
        isRefreshing?(true)
        // 네트워킹 시작
        networkingService.searchBooks(withQuery: "swift",startIndex: 0) { [weak self] searchResponse in
            print(self?.TAG,"networkingService.searchBooks함수 시작 - searchResponse : \(searchResponse)")
            guard searchResponse.items.count > 0 else { return print("네트워크 통신 결과 없음") }
            guard let strongSelf = self else { return }
            strongSelf.finishSearching(with: searchResponse)
        }
    }
    
    func pagenation(query: String, startIndex: Int) {
        isRefreshing?(true)
        // 네트워킹 시작
        throttle.throttle {
            self.startpagenation(withQuery: query, startIndex: startIndex)
        }
    }
    
    //Inputs
    func didChangeQuery(_ query: String) {
        print(TAG,"didChangeQuery 함수 시작 query : \(query)")
        // 검색창 변화를 탐지하기 위함
        guard query.count > 2,
              query != lastQuery else { return }
        
        throttle.throttle {
            self.startSearchWithQuery(query)
        }
        
        
    }
    
    // SearchBar에서 검색 시작
    private func startSearchWithQuery(_ query: String) {
        print(TAG,"startSearchWithQuery 함수 시작 query : \(query)")
        // 기존에 진행중이던 네트워킹 차단
        currentSearchNetworkTask?.cancel()
        
        isRefreshing?(true)
        
        //
        currentSearchNetworkTask = networkingService.searchBooks(withQuery: query,startIndex: 0, completion: { [weak self] searchResponse in
        
            guard let strongSelf = self else { return }
            strongSelf.finishSearching(with: searchResponse)
        })
        
    }
    
    private func startpagenation(withQuery: String, startIndex: Int){
        print(TAG," startpagenation 함수 시작 withQuery : \(withQuery) startIndex : \(startIndex)")
        // 기존에 진행중이던 네트워킹 차단
        currentSearchNetworkTask?.cancel()
        isRefreshing?(true)
        currentSearchNetworkTask = networkingService.searchBooks(withQuery: withQuery, startIndex: startIndex, completion: { [weak self] searchResponse in
            
            guard let strongSelf = self else { return }
            strongSelf.addSearching(with: searchResponse)
            
        })
        
    }

    // 네트워킹 완료후 Model을 ViewModel로 넘겨줌 -> DataBinding 시작함.
    private func finishSearching(with searchResponse: SearchResponse) {
        print(TAG," finishSearching 함수 시작 : \(searchResponse)")
        isRefreshing?(false)
        self.items = searchResponse.items
        self.totalItem = searchResponse.totalItems
    }
    
    private func addSearching(with searchResponse: SearchResponse) {
        print(TAG," addSearching 함수 시작 : \(searchResponse)")
        isRefreshing?(false)
        self.items = items + searchResponse.items
        print(TAG," addSearching 함수 items : \(self.items)")
        self.totalItem = searchResponse.totalItems
    }
    
}

struct SearchItemModel{
    
    let TAG = "SearchItemViewModel"
    let title: String
    let authors: [String]
    let date: String
    let tumbnail: String
    let infoLink: String
    
    init(volumeInfoModel: volumeInfoModel) {
        self.title = volumeInfoModel.title
        self.authors = volumeInfoModel.authors
        self.date = volumeInfoModel.publishedDate
        self.tumbnail = volumeInfoModel.smallThumbnail
        self.infoLink = volumeInfoModel.infoLink
        print(TAG,"volumeInfoModel - init")
        print(TAG,"volumeInfoModel - init self.title : \(self.title)")
        print(TAG,"volumeInfoModel - init self.authors : \(self.authors)")
        print(TAG,"volumeInfoModel - init self.date : \(self.date)")
        print(TAG,"volumeInfoModel - init self.tumbnail : \(self.tumbnail)")
        print(TAG,"********************************************")
    }
    
    
}

//extension SearchItemViewModel {
//
//    init(volumeInfoModel: volumeInfoModel) {
//        self.title = volumeInfoModel.title
//        self.authors = volumeInfoModel.authors
//        self.date = volumeInfoModel.publishedDate
//        self.tumbnail = volumeInfoModel.smallThumbnail
//    }
//
//}
