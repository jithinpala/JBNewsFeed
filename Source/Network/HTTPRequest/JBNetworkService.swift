//
//  JBNetworkService.swift
//  JBNewsFeed
//
//  Created by Jithin Balan on 30/8/21.
//

import Foundation

typealias HTTPHeaders = [String: String]

final class JBNetworkService: NSObject {
    private var resourceTimeout: TimeInterval = 60
    private(set) var session: URLSession!
    
    typealias DataTaskCompletionHandler = (Result<(URLResponse, Data), JBNetworkError>) -> Void
    
    enum HeaderKeys {
        static let apiKey = "x-api-key"
        static let apiValue = "r-ettAnj4MCpO-jc2gaHQzJ_C44G-uJcfAUaCm6BO4s"
    }
    
    init(configuration: URLSessionConfiguration? = nil) {
        super.init()
        session = makeSession(configuration: configuration)
    }
    
    private func makeDefaultHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        headers[HeaderKeys.apiKey] = HeaderKeys.apiValue
        return headers
    }
    
    private func makeSession(configuration: URLSessionConfiguration? = nil) -> URLSession {
        guard let configuration = configuration else {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForResource = resourceTimeout
            return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
        }
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
    }
    
    func genericDataTask(withRequest request: URLRequest, completion: @escaping DataTaskCompletionHandler) {
        var mutableRequest = request
        mutableRequest.addHeaders(headers: makeDefaultHeaders())
        
        let task = session.dataTask(with: mutableRequest) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            DispatchQueue.main.async {
                if let error = self?.parseNetworkErrors(with: data, response: response, error: error) {
                    completion(.failure(error))
                } else {
                    if let data = data, let response = response, let httpResponse = response as? HTTPURLResponse {
                        if (httpResponse.statusCode >= 200) && (httpResponse.statusCode < 300) {
                            completion(.success((response, data)))
                        } else {
                            var userInfo: [String: Any] = [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode), "errorResponseBody": data]

                            if let errorJSON = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)) as? [String: Any] {
                                userInfo["errorResponseJSON"] = errorJSON
                            }

                            let serverError = NSError(domain: "JBNetworking", code: httpResponse.statusCode, userInfo: userInfo)
                            completion(.failure(JBNetworkError.undefined(error: serverError as Error)))
                        }
                    } else {
                        completion(.failure(JBNetworkError.undefined(error: nil)))
                    }
                }
            }
        }
        task.resume()
    }
    
    private func parseNetworkErrors(with data: Data?, response: URLResponse?, error: Error?) -> JBNetworkError? {
        if let error = error {
            return JBNetworkError(error)
        }
        guard let response = response as? HTTPURLResponse else {
            return .undefined(error: nil)
        }
        
        if HTTPStatusCode(rawValue: response.statusCode) != .success {
          let statusCode = HTTPStatusCode(rawValue: response.statusCode)
          let error = JBNetworkError.badRequest(withStatusCode: statusCode, responseError: error)
          return error
        }

        return nil
    }
}
