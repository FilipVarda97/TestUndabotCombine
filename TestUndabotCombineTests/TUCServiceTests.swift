//
//  TUCServiceTests.swift
//  TestUndabotCombineTests
//
//  Created by Filip Varda on 19.03.2023..
//

import XCTest
import Combine
@testable import TestUndabotCombine

final class TUCServiceTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    func test_fetchRepositories() {
        let sut = TUCService()
        let requsest = TUCRequest(enpoint: .searchRepositories, queryParams: [URLQueryItem(name: "q", value: "Repo")])
        sut.execute(requsest, expected: TUCRepositoriesResponse.self).sink {_ in} receiveValue: { response in
            XCTAssertTrue(response.items.count > 0)
        }
    }

    func test_fetchUser() {
        let sut = TUCService()
        let requsest = TUCRequest(url: URL(string: "https://api.github.com/users/github")!)!
        sut.execute(requsest, expected: TUCUser.self).sink {_ in} receiveValue: { user in
            XCTAssertTrue(user.name == "github")
        }
    }
}
