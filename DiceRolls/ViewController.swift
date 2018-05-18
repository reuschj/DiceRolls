//
//  ViewController.swift
//  DiceRolls
//
//  Created by Justin Reusch on 3/27/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
	
	@IBOutlet var setTimes: NSTextField!
  @IBOutlet var outputArea: NSTextFieldCell!
	
	@IBAction func testButton(_ sender: NSButton) {
		// Make a few people
		let Katherine = Person(name: Name(first: "Katherine"))
		let Zack = Person(name: Name(first: "Zack"))
		let Justin = Person(name: Name(first: "Justin", middle: "Alexander", last: "Reusch"), gender: .male)
		let Hang = Person(name: Name(first: "Hang", last: "Reusch"), gender: .female)
		
		// Make the dice
		var dice = [Die]()
		dice.append(Die(sides: [3,3,3,3,3,6], owner: Katherine))
		dice.append(Die(sides: [2,2,2,5,5,5], owner: Zack))
		dice.append(Die(sides: [3,3,3,3,3,6], owner: Justin))
		dice.append(Die(sides: [2,2,2,5,5,5], owner: Hang))
		dice.append(Die(sides: [1,2,3,4,5,6], owner: Justin))
		dice.append(Die(sides: [1,2,3,4,5,6], owner: Hang))
		
		var numTimesToRoll: Int
		if setTimes.stringValue == "" {
			numTimesToRoll = 100
		} else {
			numTimesToRoll = Int(setTimes.intValue)
		}
		
		let result = rollXTimes(timesToRoll: numTimesToRoll, listOfDiceToRoll: dice)
    outputArea.stringValue = result.reportString
		print(result.reportString)
	}

	
	
}

