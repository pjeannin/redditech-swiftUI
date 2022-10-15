//
//  RedditService.swift
//  Redditech
//
//  Created by Pierre Jeannin on 14/10/2022.
//

import Foundation

struct TokenResponse: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let refreshToken: String
    let scope: String
}

struct RedditService {
    
    let clientId: String = "dUxErvdbUGrVgwX4ZMHD8A"
    let redirectUri: String = "http://pierre.sfsu/loggedin"
    let state: String = "buy_AirPods"
    let grantType: String = "authorization_code"
    var loginUrl: URL? {
        URL.init(string: "https://www.reddit.com/api/v1/authorize.compact?client_id=\(clientId)&response_type=code&state=\(state)&redirect_uri=\(redirectUri)&duration=permanent&scope=*")
    }
    
    private func getTokenUrl(code: String) -> URL? {
        return URL.init(string: "https://www.reddit.com/api/v1/access_token?redirect_uri=\(redirectUri)&grant_type=\(grantType)&code=\(code)")
    }
    
    private func getAuthorizationEncodedCode(from code: String) -> String {
        return "\(clientId):\(code)".data(using: .utf8)?.base64EncodedString() ?? ""
    }
    
    private func fetchToken(with authorizationCode: String, and code: String, onCompleted: @escaping (String) -> Void,  onFailure: @escaping () -> Void) {
        guard let url: URL = getTokenUrl(code: code) else { return }
        
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = "POST"
        request.addValue("Basic \(authorizationCode)", forHTTPHeaderField: "Authorization")
        let session: URLSession = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response, error) -> Void in
            guard let data = data else {
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
                onCompleted(tokenResponse.accessToken)
            } catch {
                onFailure()
                print(error)
            }
        }
        task.resume()
    }
    
    func getToken(from redirectUri: String, onCompleted: @escaping (String) -> Void, onFailure: @escaping () -> Void) {
        guard let url = URLComponents(string: redirectUri) else { return }
        guard let code = url.queryItems?.first(where: { $0.name == "code" })?.value else { return }
        let authorization = getAuthorizationEncodedCode(from: code)
        fetchToken(with: authorization, and: code, onCompleted: onCompleted, onFailure: onFailure)
    }
}
