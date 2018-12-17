//
//  PlayareaTest.swift
//  SwiftCardsTests
//
//  Created by Caitlin Cooling on 12/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import XCTest
@testable import SwiftCards

class PlayareaTest: XCTestCase {

    var card: Card!
    var playarea: Playarea!
    override func setUp() {
        card = Card(value: "2", suit: "hearts")
        playarea = Playarea()
    }
    func testAttributes() {
        XCTAssertEqual(playarea.cards.count, 0)
    }
    func testAddCard() {
        playarea.add(card: card)
        XCTAssertEqual(playarea.cards.count, 1)
    }
    func testRemoveCard() {
        playarea.add(card: card)
        let removedCard = playarea.remove(card: card)
        XCTAssertEqual(playarea.cards.count, 0)
        XCTAssertEqual(removedCard, card)
    }
}
