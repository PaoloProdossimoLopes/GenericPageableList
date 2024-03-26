//
//  SceneDelegate.swift
//  GenericList
//
//  Created by Paolo Prodossimo Lopes on 22/03/24.
//

import UIKit

class URLNetworkClient: NetworkClient {
    var count = 1
    func perform<NetworkDto: Decodable>(_ request: NetworkRequest, completion: @escaping NetworkCompletion<NetworkDto>) {
        var url: URL
        if request.endpoint == .current {
            url = URL(string: "https://da09d166189f41c187ddf4df98e9732a.api.mockbin.io")!
        } else {
            url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        }
        url.append(queryItems: request.query.map(URLQueryItem.init))
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let decoder = JSONDecoder()
            let resourceModel = try! decoder.decode(NetworkDto.self, from: data!)
            self.count += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
//                if self.count == 2 {
//                    completion(.success(resourceModel))
//                } else if self.count ==  3 {
//                    completion(.failure(TableError()))
//                } else {
//                    completion(.success(.init(events: resourceModel.events, pagination: .init(nextPage: self.count, totalPage: 3))))
////                    completion(.success(.init(events: resourceModel.events, pagination: nil)))
//                }
                
//                if Bool.random() {
//                    completion(.success(resourceModel))
//                } else {
//                    completion(.failure(TableError()))
//                }
                
//                completion(.success(.init(events: resourceModel.events, pagination: nil)))
                completion(.success(resourceModel))
            }
        }
        .resume()
    }
}

class LocalFeatureToggle: FeatureToggle {
    func isOn(_ toggle: Toggle) -> Bool {
        true
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var coordinator: Coordinator?
    private let provider = Provider(
        networkClient: URLNetworkClient(),
        featureToggle: LocalFeatureToggle()
    )

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let newWindow = UIWindow(windowScene: windowScene)
        
        window = newWindow
        coordinator = Coordinator(provider: provider, window: newWindow)
        coordinator?.start()
    }
}
