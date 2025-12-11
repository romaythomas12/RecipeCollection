//
//  APIRequest.swift
//  Core
//
//  Created by Thomas Romay on 11/12/2025.
//
import Foundation

// MARK: - Request Builder

public struct APIRequest {
    public let url: URL
    public let method: String
    public let headers: [String: String]
}

public enum ApiMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
}

public struct APIRequestBuilder {
    private var scheme: String = "https"
    private var host: String
    private var path: String = ""
    private var queryItems: [URLQueryItem] = []
    private var method: String = ApiMethod.get.rawValue
    private var headers: [String: String] = [:]

    public init(host: String) {
        self.host = host
    }

    public func setPath(_ path: String) -> APIRequestBuilder {
        var copy = self
        copy.path = path
        return copy
    }

    public func addQueryItem(name: String, value: String) -> APIRequestBuilder {
        var copy = self
        copy.queryItems.append(URLQueryItem(name: name, value: value))
        return copy
    }

    public func setMethod(_ method: String) -> APIRequestBuilder {
        var copy = self
        copy.method = method
        return copy
    }

    public func addHeader(name: String, value: String) -> APIRequestBuilder {
        var copy = self
        copy.headers[name] = value
        return copy
    }

    public func build() throws -> APIRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        if !queryItems.isEmpty { components.queryItems = queryItems }
        guard let url = components.url else { throw NetworkError.urlError }
        return APIRequest(url: url, method: method, headers: headers)
    }
}

extension URLRequest {
    init(apiRequest: APIRequest) {
        self.init(url: apiRequest.url)
        self.httpMethod = apiRequest.method
        apiRequest.headers.forEach { key, value in
            self.setValue(value, forHTTPHeaderField: key)
        }
    }
}
