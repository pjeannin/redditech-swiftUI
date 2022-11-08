//
//  RedditService.swift
//  Redditech
//
//  Created by Pierre Jeannin on 14/10/2022.
//

import Foundation

struct RedditService {
    
    let clientId: String = "dUxErvdbUGrVgwX4ZMHD8A"
    let redirectUri: String = "http://pierre.sfsu/loggedin"
    let state: String = "buy_AirPods"
    let grantType: String = "authorization_code"
    var loginUrl: URL? {
        URL.init(string: "https://www.reddit.com/api/v1/authorize.compact?client_id=\(clientId)&response_type=code&state=\(state)&redirect_uri=\(redirectUri)&duration=permanent&scope=*")
    }
    let baseUrl: String = "https://oauth.reddit.com"
    let logout: () -> Void
    
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
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
                print("The access token is \(tokenResponse.accessToken)")
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
    
    func fetchMe(onCompleted: @escaping (MeResponse) -> Void, onFailure: @escaping () -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)/api/v1/me?raw_json=1")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onFailure()
            return
        }
        let accessToken = String(decoding: dataAccessToken, as: UTF8.self)
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = "GET"
        request.addValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let session: URLSession = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response, error) -> Void in
            guard let res: HTTPURLResponse = response as? HTTPURLResponse else {
                onFailure()
                return
            }
            if res.statusCode == 401 {
                logout()
                return
            }
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let me = try decoder.decode(MeResponse.self, from: data)
                onCompleted(me)
            } catch {
                onFailure()
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchUserPosts(_ username: String, onCompleted: @escaping (ListPostResponse) -> Void, onFailure: @escaping () -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)/user/\(username)/new?sr_detail=sr_detail&raw_json=1")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onFailure()
            return
        }
        let accessToken = String(decoding: dataAccessToken, as: UTF8.self)
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = "GET"
        request.addValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let session: URLSession = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response, error) -> Void in
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let usersPosts = try decoder.decode(ListPostResponse.self, from: data)
                onCompleted(usersPosts)
            } catch {
                onFailure()
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchSearch(_ toSearch: String, onCompleted: @escaping (SearchResponse) -> Void, onFailure: @escaping () -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)//subreddits/search?limit=100&q=\(toSearch)&raw_json=1")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onFailure()
            return
        }
        let accessToken = String(decoding: dataAccessToken, as: UTF8.self)
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = "GET"
        request.addValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let session: URLSession = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response, error) -> Void in
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let subreddits = try decoder.decode(SearchResponse.self, from: data)
                onCompleted(subreddits)
            } catch {
                onFailure()
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchMePrefs(onCompleted: @escaping (PrefsResponse) -> Void, onFailure: @escaping () -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)/api/v1/me/prefs?raw_json=1")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onFailure()
            return
        }
        let accessToken = String(decoding: dataAccessToken, as: UTF8.self)
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = "GET"
        request.addValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let session: URLSession = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response, error) -> Void in
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let prefs = try decoder.decode(PrefsResponse.self, from: data)
                onCompleted(prefs)
            } catch {
                onFailure()
                print(error)
            }
        }
        task.resume()
    }
    
    func patchPrefs(with newPrefs: PrefsResponse, onCompleted: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)/api/v1/me/prefs")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onFailure("Fail to create URL")
            return
        }
        let accessToken = String(decoding: dataAccessToken, as: UTF8.self)
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = "PATCH"
        request.addValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        print(newPrefs)
        do {
            let body = try encoder.encode(newPrefs)
            request.httpBody = body
        } catch {
            onFailure("Fail to encode body")
        }
        let session: URLSession = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response, error) -> Void in
            guard let res: HTTPURLResponse = response as? HTTPURLResponse else {
                onFailure("Fail to convert URLResponse to HTTPURLResponse")
                return
            }
            if (res.statusCode == 200) {
                onCompleted()
            } else {
                onFailure(res.description + "" + res.debugDescription)
            }
        }
        task.resume()
    }
    
    func fetchHomePosts(postType: PostSource, onCompleted: @escaping (ListPostResponse) -> Void, onFailure: @escaping () -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)/\(postType == .hot ? "hot" : (postType == .new ? "new" : "top"))?sr_detail=sr_detail&raw_json=1")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onFailure()
            return
        }
        let accessToken = String(decoding: dataAccessToken, as: UTF8.self)
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = "GET"
        request.addValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let session: URLSession = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response, error) -> Void in
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let usersPosts = try decoder.decode(ListPostResponse.self, from: data)
                onCompleted(usersPosts)
            } catch {
                onFailure()
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchSubreddit(_ subredditName: String, onCompleted: @escaping (SubredditDetailsResponse) -> Void, onFailure: @escaping () -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)/\(subredditName)/about?raw_json=1")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onFailure()
            return
        }
        let accessToken = String(decoding: dataAccessToken, as: UTF8.self)
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = "GET"
        request.addValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let session: URLSession = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response, error) -> Void in
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let subreddit = try decoder.decode(SubredditDetailsResponse.self, from: data)
                onCompleted(subreddit)
            } catch {
                onFailure()
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchPostsOf(subreddit subredditName: String, onCompleted: @escaping (ListPostResponse) -> Void, onFailure: @escaping () -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)/\(subredditName)/new?sr_detail=sr_detail&raw_json=1")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onFailure()
            return
        }
        let accessToken = String(decoding: dataAccessToken, as: UTF8.self)
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = "GET"
        request.addValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let session: URLSession = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response, error) -> Void in
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let usersPosts = try decoder.decode(ListPostResponse.self, from: data)
                onCompleted(usersPosts)
            } catch {
                onFailure()
                print(error)
            }
        }
        task.resume()
    }
    
    func subscribeOrUnsubscribe(to subredditName: String, value: Bool, onCompleted: @escaping (String) -> Void, onFailure: @escaping () -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)/api/subscribe?action=\(value ? "sub" : "unsub")&sr_name=\(subredditName)")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onFailure()
            return
        }
        let accessToken = String(decoding: dataAccessToken, as: UTF8.self)
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = "POST"
        request.addValue("bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let session: URLSession = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response, error) -> Void in
            guard let res: HTTPURLResponse = response as? HTTPURLResponse else {
                onFailure()
                return
            }
            if (res.statusCode == 200) {
                onCompleted(subredditName)
            } else {
                onFailure()
            }
        }
        task.resume()
    }

}
