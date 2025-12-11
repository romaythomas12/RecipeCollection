//
//  MockNetworkSession.swift
//  Core
//
//  Created by Thomas Romay on 11/12/2025.
//

@testable import Core
import Foundation

struct MockNetworkSession: NetworkSessionProtocol, Sendable {
    let dataResult: Result<(Data, URLResponse), Error>

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        switch dataResult {
            case .success(let out):
                return out
            case .failure(let err):
                throw err
        }
    }
}
