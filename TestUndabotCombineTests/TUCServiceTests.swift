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
    private var sut: ServiceExecutable!

    override func setUp() {
        super.setUp()
        cancellables = []
        sut = TUCService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_fetchRepositories() {
        let request = TUCRequest(enpoint: .searchRepositories, queryParams: [URLQueryItem(name: "q", value: "Repo")])
        sut.execute(request, expected: TUCRepositoriesResponse.self).sink {_ in} receiveValue: { response in
            XCTAssertTrue(response.items.count > 0)
        }
    }

    func test_fetchUser() {
        let request = TUCRequest(url: URL(string: "https://api.github.com/users/github")!)!
        sut.execute(request, expected: TUCUser.self).sink {_ in} receiveValue: { user in
            XCTAssertTrue(user.name == "github")
        }
    }
}
