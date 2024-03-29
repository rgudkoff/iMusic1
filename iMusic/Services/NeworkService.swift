//
//  NeworkService.swift
//  iMusic
//
//  Created by Роман Гудков on 04.01.2023.
//

import UIKit
import Alamofire

class NetworkService {
    
    func fetchTracks(searchText: String, completion: @escaping (SearchResponse?) -> Void) {
        print(searchText)
        let url = "https://itunes.apple.com/search"
        let parameters = ["term":"\(searchText)",
                         "limit":"10",
                          "media":"music"]
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let error = dataResponse.error {
                print("Error recived requesting data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = dataResponse.data else {return}
            
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SearchResponse.self, from: data)
                print("objects: ",objects)
                completion(objects)
                
            } catch let jsonError {
                print("Faile to decode JSON ", jsonError)
                completion(nil)
            }
           // let someString = String(data: data, encoding: .utf8)
           // print(someString ?? "")
        }
        
    }
}
