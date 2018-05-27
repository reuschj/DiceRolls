//
//  Roll.swift
//  DiceRolls
//
//  Created by Justin Reusch on 4/29/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Foundation

class Roll {
	let id: String
	let rollNum: Int
	var die: Die
	var result: Int
	static var rollCounter: Int = 0
	
	init(die: Die, result: Int) {
		self.die = die
		self.result = result
		self.id = "roll\(String(Roll.rollCounter + 1))"
		self.rollNum = Roll.rollCounter + 1
		Roll.rollCounter += 1
	}
	
	func compareTo(_ anotherRoll: Roll) -> Result {
		let ownerTag = self.die.owner != nil ? "\(self.die.owner!.name.shortName): " : ""
		if self.result > anotherRoll.result {
			print(ownerTag + "I win! :)")
			return Result.win
		} else if self.result < anotherRoll.result {
			print(ownerTag + "I lose! :(")
			return Result.loss
		} else {
			print(ownerTag + "We tied.")
			return Result.tie
		}
	}
	func report() -> String {
		var resultString: String
		var ownerTag: String
		if let possibleOwner = self.die.owner {
			ownerTag = "\(possibleOwner.name.shortName): "
		} else {
			ownerTag = ""
		}
		resultString = ownerTag + "I rolled and got a \(String(self.result))."
		return resultString
	}
}

extension Roll: Hashable {
	var hashValue: Int {
		return rollNum.hashValue * 128
	}
	
	static func == (lhs: Roll, rhs: Roll) -> Bool {
		return lhs.rollNum == rhs.rollNum
	}
}
