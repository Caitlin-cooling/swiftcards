//
//  GameViewController.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 12/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import UIKit

let player = Player()
var game = Game(handSize: 5, players: [player])
let playarea = Playarea()

class GameViewController: UIViewController {
    @IBOutlet weak var deckImage: UIImageView!
    @IBOutlet weak var handView: UIView!
    @IBOutlet weak var playareaView: UIView!
    var handSize: Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        game.handSize = handSize
        game.deck.shuffle()
        game.deal()
        renderHand(player.hand, location: handView)
    }
    @IBAction func deckTapped(_ sender: Any) {
        if player.hand.cards.count < 10 {
            player.draw(deck: game.deck)
        }
        renderHand(player.hand, location: handView)
    }
    @objc func imageTapped(tap: UITapGestureRecognizer) {
        let tappedImage = tap.view as! UIImageView
        let tappedCard = getCardObject(image: tappedImage)
        if player.hand.cards.contains(tappedCard) {
            player.play(card: tappedCard, location: playarea)
            makeDraggable(imageView: tappedImage)
        } else {
            player.reclaim(card: tappedCard, from: playarea)
            removeDraggable(imageView: tappedImage)
        }
        renderHand(player.hand, location: handView)
        renderPlayarea(playarea, location: playareaView)
    }
    @objc func pan(drag: UIPanGestureRecognizer) {
        let touchedImage = drag.view as! UIImageView
        
        // get new origin
        let translation = drag.translation(in: touchedImage)
        let newX = touchedImage.frame.origin.x + translation.x
        let newY = touchedImage.frame.origin.y + translation.y
        
        // update model if new position is valid
        let newOrigin = CGPoint(x: newX, y: newY)
        if validPosition(newOrigin, image: touchedImage) {
            let touchedCard = getCardObject(image: touchedImage)
            touchedCard.setCoords(x: Float(newX), y: Float(newY))
        }

        // update the view from the model
        renderPlayarea(playarea, location: playareaView)

        // bring card to front
        playareaView.bringSubview(toFront: touchedImage)

        // reset translation to zero (otherwise it's cumulative)
        drag.setTranslation(.zero, in: touchedImage)

        // send data when the gesture has finished
        if drag.state == UIGestureRecognizerState.ended {
            // TODO: send data
        }
    }

    func makeTappable(imageView: UIImageView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tap:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }

    func makeDraggable(imageView: UIImageView) {
        let drag = UIPanGestureRecognizer(target: self, action: #selector(pan))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(drag)
    }

    func removeDraggable(imageView: UIImageView) {
        let drag = UIPanGestureRecognizer(target: self, action: #selector(pan))
        imageView.removeGestureRecognizer(drag)
    }

    func validPosition(_ position: CGPoint, image: UIImageView) -> Bool {
        var newFrame = image.frame
        let absolutePosition = playareaView.convert(position, to: nil)
        newFrame.origin = absolutePosition
        if playareaView.frame.contains(newFrame) {
            return true
        } else {
            return false
        }
    }
    func renderHand(_ hand: Hand, location: UIView) {
        for card in hand.cards {
            let leftPosition = Float(hand.cards.index(of: card)! * 30)
            card.setCoords(x: leftPosition, y: 0.0)
            render(card, location: handView)
        }
    }
    func renderPlayarea(_ playarea: Playarea, location: UIView) {
        for card in playarea.cards {
            render(card, location: playareaView)
        }
    }
    func render(_ card: Card, location: UIView) {
        let cardView = imageView(card)
        location.addSubview(cardView)
        let xPosition = CGFloat(card.xPosition)
        let yPosition = CGFloat(card.yPosition)
        cardView.frame.origin = CGPoint(x: xPosition, y: yPosition)
    }
    func imageView(_ card: Card) -> UIImageView {
        let allViews = playareaView.subviews + handView.subviews
        if let existingView = allViews.first(where: {$0.accessibilityIdentifier == card.name}) {
            return existingView as! UIImageView
        } else {
            let image = UIImage(named: card.name + ".png")
            let imageView = UIImageView(image: image!)
            imageView.isAccessibilityElement = true
            imageView.accessibilityIdentifier = card.name
            imageView.frame = CGRect(x: 0, y: 0, width: 90, height: 130)
            makeTappable(imageView: imageView)
            return imageView
        }
    }
    func getCardObject(image: UIImageView) -> Card {
        return Card.find(name: image.accessibilityIdentifier!)
    }
}
