//
//  Die.swift
//  DiceRolls
//
//  Created by Justin Reusch on 4/29/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Foundation

class Die {
	let id: String
	let dieNum: Int
	let sides: [Int]
	let sideCount: Int
	var owner: Person?
	var name: String
	static var countOfDice: Int = 0
	
	init(sides: [Int], owner: Person? = nil) {
		self.sides = sides
		self.sideCount = sides.count
		var ownerNameForID = "Nobody"
		if let possibleOwner = owner {
			self.owner = possibleOwner
			ownerNameForID = possibleOwner.name.shortName
			self.name = "\(possibleOwner.name.shortName)'s die with \(sides.count) sides"
		} else {
			self.owner = nil
			self.name = "A unowned die with \(sides) sides"
		}
		var sideStringForID = ""
		for side in sides {
			sideStringForID += String(side)
		}
		let indexOfThisDie = Die.countOfDice + 1
		self.id = "\(ownerNameForID)_\(String(sides.count))_\(sideStringForID)_\(String(indexOfThisDie))"
		self.dieNum = indexOfThisDie
		// Assign the die to it's owner
		if let possibleOwner = owner {
			possibleOwner.assignDie(die: self)
		}
		Die.countOfDice += 1
		
	}
	
	func assignOwner(owner: Person) {
		self.owner = owner
		owner.assignDie(die: self)
		print("The die with \(String(self.sideCount)) sides now belogs to \(owner.name.shortName).")
	}
	
	func roll() -> Roll {
		let rolledSide: Int = Int(arc4random_uniform(UInt32(self.sideCount)))
		let rollResult: Roll = Roll(die: self, result: self.sides[rolledSide])
		return rollResult
	}
	
	func identify() -> String {
		var ownerName = ""
		if let possibleOwner = self.owner {
			ownerName = possibleOwner.name.shortName
		} else {
			ownerName = "nobody"
		}
		let returnString: String = "I am a die belonging to \(ownerName) with \(String(self.sideCount)) sides: \(buildIntListToString(intArray: self.sides))"
		return returnString
	}
	
}

extension Die: Hashable {
	var hashValue: Int {
		return dieNum.hashValue * 256 / sideCount.hashValue
	}
	
	static func == (lhs: Die, rhs: Die) -> Bool {
		return lhs.dieNum == rhs.dieNum && lhs.sideCount == rhs.sideCount
	}
}
