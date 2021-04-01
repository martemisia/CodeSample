//
//  MoyaService.swift
//  Pryaniki
//
//  Created by Wermod on 11.03.2021.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper

enum MoyaService {
    case getData
}

class NetworkService {
    let provider = MoyaProvider<MoyaService>()
    func getData(completion: @escaping ((Pryaniky?) -> Void)) {
        provider.request(MoyaService.getData) { (result) in
            switch result {
                case .success(let response) :
                    let responseObj = try! JSONDecoder().decode(Pryaniky.self, from: response.data)
                    completion(responseObj)
                case .failure(let error) :
                    print(error)
                    
            }
        }
    }
}

// MARK: - TargetType Protocol Implementation
extension MoyaService: TargetType {
    
    var baseURL: URL { return URL(string: "https://pryaniky.com")! }
    var path: String {
        switch self {
            case .getData:
                return "/static/json/sample.json"
        }
    }

    var method: Moya.Method {
        return .get
    }
    var parameters: [String: Any]? {
        return nil
    }
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    var sampleData: Data {
        return Data()
    }
    var task: Task {
        return .requestPlain
    }
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
