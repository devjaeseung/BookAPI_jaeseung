//
//  NetworkingApi.swift
//  BookAPI_jaeseung
//
//  Created by jaeseung lim on 2022/08/12.
//

import Foundation

protocol NetworkingService {
    
    @discardableResult func searchBooks(withQuery query: String, startIndex: Int, completion: @escaping (SearchResponse) -> ()) -> URLSessionDataTask
    
}

final class NetworkingApi: NetworkingService {
    
    let TAG = "NetworkingApi"
    
    private let session = URLSession.shared
    
    @discardableResult
    func searchBooks(withQuery query: String, startIndex: Int, completion: @escaping (SearchResponse) -> ()) -> URLSessionDataTask {
        print(TAG,"searchBooks 함수 시작 - query : \(query)")
        // AIzaSyCkcFgJTQObIULKG50UdsNo27PcXpZVKcs -> 통신에 제한 없는 API
        // AIzaSyC6UCvdkH5CExCByMs1lcRb7ppA4f3sL5c -> IOS에서만 통신 가능한 API
        let request = URLRequest(url: URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(query)&startIndex=\(startIndex)&filter=partial&key=AIzaSyCkcFgJTQObIULKG50UdsNo27PcXpZVKcs")!)
        print(TAG,"searchBooks 함수 - request : \(request)")
        let task = session.dataTask(with: request) { (data, _, _) in
            
            DispatchQueue.main.async {
                
                guard let data = data,
                      let response = try? JSONDecoder().decode(SearchResponse.self, from: data) else {
                    completion(SearchResponse(totalItems: 0, items: []))
                    return
                }
                print(self.TAG,"searchBooks 함수 - 통신 개수 : \(response.items.count)")
                completion(response)
            }
            
        }
        task.resume()
        return task
        
    }
    
}

struct SearchResponse: Decodable {
    let totalItems: Int
    let items: [volumeInfoModel]
    
}
