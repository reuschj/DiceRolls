//
//  Die.swift
//  DiceRolls
//
//  Created by Justin Reusch on 4/29/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Foundation

class Die {
	var sides: [Int]
	var sideCount: Int
	var owner: Person?
	
	init(sides: [Int], owner: Person? = nil) {
		self.sides = sides
		self.sideCount = self.sides.count
		if let possibleOwner = owner {
			self.owner = possibleOwner
			owner?.assignDie(die: self)
		} else {
			self.owner = nil
		}
	}
	
	func assignOwner(owner: Person) {
		self.owner = owner
		owner.assignDie(die: self)
		print("The die with \(String(self.sideCount)) sides now belogs to \(owner.name).")
	}
	
	func roll() -> Roll {
		let rolledSide: Int = Int(arc4random_uniform(UInt32(self.sideCount)))
		let rollResult: Roll = Roll(die: self, result: self.sides[rolledSide])
		return rollResult
	}
	
	func identify() -> String {
		var ownerName = ""
		if let possibleOwner = self.owner {
			ownerName = possibleOwner.name
		} else {
			ownerName = "nobody"
		}
		let returnString: String = "I am a die belonging to \(ownerName) with \(String(self.sideCount)) sides: \(buildIntListToString(intArray: self.sides))"
		return returnString
	}
}

let justin = Person(name: "Justin")
let testDie = Die(sides: [1,2,3,4,5,6], owner: justin)
