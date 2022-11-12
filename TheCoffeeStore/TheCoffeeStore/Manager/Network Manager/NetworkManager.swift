//
//  NetworkManager.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 01/10/2022.
//

import Foundation
import Alamofire
class NetworkManager{
    static let shared = NetworkManager()
}

// MARK: - Address API
extension NetworkManager{
    func fetchProvinces(completion: @escaping(Result<[Province], Error>)->Void){
        let url = "\(BaseURL.addressURL)/p"
        AF.request(url).validate(statusCode: 200...201).responseDecodable(of: [Province].self) { response in
            switch response.result{
            case .success(let provinces):
                completion(.success(provinces))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchDistricts(cityCode: Int,completion: @escaping(Result<[District], Error>)->Void){
        let url = "\(BaseURL.addressURL)/p/\(cityCode)?depth=2"
        AF.request(url).validate(statusCode: 200...201).responseDecodable(of: Province.self) { response in
            switch response.result {
            case .success(let province):
                let districts = province.districts
                completion(.success(districts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchWards(districtCode: Int, completion: @escaping(Result<[Ward], Error>) -> Void){
        let url = "\(BaseURL.addressURL)/d/\(districtCode)?depth=2"
        AF.request(url).validate(statusCode: 200...201).responseDecodable(of: District.self) { response in
            switch response.result{
            case .success(let district):
                let wards = district.wards
                completion(.success(wards))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
