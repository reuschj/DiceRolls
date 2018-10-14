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
	let number: Int
	let sides: [Int]
	let sideCount: Int
	var selected: Bool
	weak var owner: Person?
	var name: String
	public var description: String { return self.name }
	static var count: Int = 0
	
	init(sides: [Int], owner: Person? = nil) {
		self.sides = sides
		self.sideCount = sides.count
		self.selected = true
		var ownerName = "Nobody"
		if let possibleOwner = owner {
			self.owner = possibleOwner
			ownerName = possibleOwner.name.shortName
			self.name = "\(ownerName)'s die with \(sides.count) sides"
		} else {
			self.owner = nil
			self.name = "A unowned die with \(sides.count) sides"
		}
		var sideStringForID = ""
		for side in sides {
			sideStringForID += String(side)
		}
		let indexOfThisDie = Die.count + 1
		self.id = "\(ownerName)_\(String(sides.count))_\(sideStringForID)_\(String(indexOfThisDie))"
		self.number = indexOfThisDie
		// Assign the die to it's owner
		if let possibleOwner = owner {
			possibleOwner.assignDie(die: self)
		}
		Die.count += 1
		
	}
	
	func assignOwner(owner: Person) {
		self.owner = owner
		owner.assignDie(die: self)
		print("The die with \(String(self.sideCount)) sides now belongs to \(owner.name.shortName).")
	}
	
	func roll() -> Roll {
		let rolledSide: Int = Int.random(in: 0 ..< self.sideCount)
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
		let returnString: String = "I am a die belonging to \(ownerName) with \(String(self.sideCount)) sides: \(buildListToString(self.sides))"
		return returnString
	}
	
	func changeSelection() -> Void {
		self.selected = !self.selected
	}
	
	func select() -> Void {
		self.selected = true
	}
	
	func deselect() -> Void {
		self.selected = false
	}
	
}

extension Die: Hashable {
	var hashValue: Int {
		return number.hashValue * 256 / sideCount.hashValue
	}
	
	static func == (lhs: Die, rhs: Die) -> Bool {
		return lhs.number == rhs.number && lhs.sideCount == rhs.sideCount
	}
}
