//
//  ChannelInteractorTests.swift
//  noodlesTests
//
//  Created by Artur Carneiro on 23/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import XCTest
@testable import noodles
import CoreData

class ChannelInteractorTests: XCTestCase {

    func testFetch() {
        let exp = expectation(description: "CloudKit Async Hell")
        let cloudkit = CloudKitManager()
        let coredata = CoreDataManager()
        let interactor = ChannelInteractor(cloudkit: cloudkit, coredata: coredata)

        var assertion = false

        interactor.fetch(with: "D10B8420-2ABC-FB27-716D-44FC8EADF781", from: .cloudkit) { (channel) in
            if channel != nil {
                print(channel)
                assertion.toggle()
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 15) { (_) in
        }

        XCTAssertTrue(assertion)
    }

    func testCoreFetch() {
        let coredata = CoreDataManager()
        let user = User(context: coredata.container.viewContext)
        let exp = expectation(description: "CoreData Fetch")
        user.id = "pokadpokae"
        user.name = "memes"

        coredata.save(object: user, of: .users) { (response) in
            print(response)
        }

        coredata.fetchAll(objects: .users) { (response) in
            if let user = response.objects?.last as? User {
                print(user.id)
                print(user.name)
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 5) { (_) in
        }
    }

}
