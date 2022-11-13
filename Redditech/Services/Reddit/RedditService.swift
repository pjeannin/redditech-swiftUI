//
//  RedditService.swift
//  Redditech
//
//  Created by Pierre Jeannin on 14/10/2022.
//

import Foundation


struct RedditService {
    
    enum RedditError: Error {
        case cannotBuildUrl
        case emptyData
        case failToDecodeDatas
        case failToConvertResponseToHTTPURLResponse
        case failToEncodeBody
        case taskFailed
        
        func print() -> Void {
            var toPrint: String = "## Reddit Error "
            switch self {
            case .cannotBuildUrl:
                toPrint += "Cannot build url"
                break
            case .emptyData:
                toPrint += "Empty data"
                break
            case .failToDecodeDatas:
                toPrint += "Fail to decode datas"
                break
            case .failToConvertResponseToHTTPURLResponse:
                toPrint += "Fail to convert response to HTTPURLResponse"
                break
            case .failToEncodeBody:
                toPrint += "Fail to encode body"
                break
            case .taskFailed:
                toPrint += "Task failed"
                break
            }
            Swift.print(toPrint)
        }
    }
    
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
    
    private func fetchToken(with authorizationCode: String, and code: String, onCompleted: @escaping (Result<String, RedditError>) -> Void) {
        guard let url: URL = getTokenUrl(code: code) else {
            onCompleted(.failure(.cannotBuildUrl))
            return
        }
        
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = "POST"
        request.addValue("Basic \(authorizationCode)", forHTTPHeaderField: "Authorization")
        let session: URLSession = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response, error) -> Void in
            guard let data = data else {
                onCompleted(.failure(.emptyData))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
                print("The access token is \(tokenResponse.accessToken)")
                onCompleted(.success(tokenResponse.accessToken))
            } catch {
                onCompleted(.failure(.failToDecodeDatas))
                print(error)
            }
        }
        task.resume()
    }
    
    func getToken(from redirectUri: String, onCompleted: @escaping (Result<String, RedditError>) -> Void) {
        guard let url = URLComponents(string: redirectUri) else { return }
        guard let code = url.queryItems?.first(where: { $0.name == "code" })?.value else { return }
        let authorization = getAuthorizationEncodedCode(from: code)
        fetchToken(with: authorization, and: code, onCompleted: onCompleted)
    }
    
    func fetchMe(onCompleted: @escaping (Result<MeResponse, RedditError>) -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)/api/v1/me?raw_json=1")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onCompleted(.failure(.cannotBuildUrl))
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
                onCompleted(.failure(.failToConvertResponseToHTTPURLResponse))
                return
            }
            if res.statusCode == 401 {
                logout()
                return
            }
            guard let data = data else {
                onCompleted(.failure(.failToDecodeDatas))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let me = try decoder.decode(MeResponse.self, from: data)
                onCompleted(.success(me))
            } catch {
                onCompleted(.failure(.failToDecodeDatas))
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchUserPosts(_ username: String, onCompleted: @escaping (Result<ListPostResponse, RedditError>) -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)/user/\(username)/new?sr_detail=sr_detail&raw_json=1")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onCompleted(.failure(.cannotBuildUrl))
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
                onCompleted(.success(usersPosts))
            } catch {
                onCompleted(.failure(.failToDecodeDatas))
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchSearch(_ toSearch: String, onCompleted: @escaping (Result<SearchResponse, RedditError>) -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)//subreddits/search?limit=100&q=\(toSearch)&raw_json=1")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onCompleted(.failure(.cannotBuildUrl))
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
                onCompleted(.failure(.emptyData))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let subreddits = try decoder.decode(SearchResponse.self, from: data)
                onCompleted(.success(subreddits))
            } catch {
                onCompleted(.failure(.failToDecodeDatas))
            }
        }
        task.resume()
    }
    
    func fetchMePrefs(onCompleted: @escaping (Result<PrefsResponse, RedditError>) -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)/api/v1/me/prefs?raw_json=1")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onCompleted(.failure(.cannotBuildUrl))
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
                onCompleted(.success(prefs))
            } catch {
                onCompleted(.failure(.failToDecodeDatas))
                print(error)
            }
        }
        task.resume()
    }
    
    func patchPrefs(with newPrefs: PrefsResponse, onCompleted: @escaping (Result<String,RedditError>) -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)/api/v1/me/prefs")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onCompleted(.failure(.cannotBuildUrl))
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
            onCompleted(.failure(.failToEncodeBody))
        }
        let session: URLSession = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response, error) -> Void in
            guard let res: HTTPURLResponse = response as? HTTPURLResponse else {
                onCompleted(.failure(.failToConvertResponseToHTTPURLResponse))
                return
            }
            if (res.statusCode == 200) {
                onCompleted(.success(""))
            } else {
                onCompleted(.failure(.failToDecodeDatas))
            }
        }
        task.resume()
    }
    
    func fetchHomePosts(postType: PostSource, onCompleted: @escaping (Result<ListPostResponse, RedditError>) -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)/\(postType == .hot ? "hot" : (postType == .new ? "new" : "top"))?sr_detail=sr_detail&raw_json=1")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onCompleted(.failure(.cannotBuildUrl))
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
                onCompleted(.success(usersPosts))
            } catch {
                onCompleted(.failure(.failToDecodeDatas))
            }
        }
        task.resume()
    }
    
    func fetchSubreddit(_ subredditName: String, onCompleted: @escaping (Result<SubredditDetailsResponse, RedditError>) -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)/\(subredditName)/about?raw_json=1")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onCompleted(.failure(.cannotBuildUrl))
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
                onCompleted(.failure(.emptyData))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let subreddit = try decoder.decode(SubredditDetailsResponse.self, from: data)
                onCompleted(.success(subreddit))
            } catch {
                onCompleted(.failure(.failToDecodeDatas))
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchPostsOf(subreddit subredditName: String, onCompleted: @escaping (Result<ListPostResponse, RedditError>) -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)/\(subredditName)/new?sr_detail=sr_detail&raw_json=1")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onCompleted(.failure(.cannotBuildUrl))
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
                onCompleted(.failure(.emptyData))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let usersPosts = try decoder.decode(ListPostResponse.self, from: data)
                onCompleted(.success(usersPosts))
            } catch {
                onCompleted(.failure(.failToDecodeDatas))
            }
        }
        task.resume()
    }
    
    func subscribeOrUnsubscribe(to subredditName: String, value: Bool, onCompleted: @escaping (Result<String, RedditError>) -> Void) {
        let maybeUrl: URL? = URL.init(string: "\(baseUrl)/api/subscribe?action=\(value ? "sub" : "unsub")&sr_name=\(subredditName)")
        let maybeAccessToken = KeychainManager.get(service: "reddit", account: "currentUser")
        guard let url: URL = maybeUrl, let dataAccessToken: Data = maybeAccessToken else {
            onCompleted(.failure(.cannotBuildUrl))
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
                onCompleted(.failure(.failToConvertResponseToHTTPURLResponse))
                return
            }
            if (res.statusCode == 200) {
                onCompleted(.success(subredditName))
            } else {
                onCompleted(.failure(.taskFailed))
            }
        }
        task.resume()
    }

}
