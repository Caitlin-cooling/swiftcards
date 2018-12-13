//
//  PlayerTest.swift
//  SwiftCardsTests
//
//  Created by Irina Baldwin on 11/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import XCTest
@testable import SwiftCards

class PlayerTest: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testPlayerHasHandOfCertainSize() {
        let player = Player()
        XCTAssertEqual(player.hand.cards.count, 0)
    }
    func testPlayerCanDraw() {
        let player = Player()
        let deck = Deck()
        player.draw(deck: deck)
        XCTAssertEqual(player.hand.cards.count, 1)
    }
}