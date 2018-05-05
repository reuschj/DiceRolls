//
//  Roll.swift
//  DiceRolls
//
//  Created by Justin Reusch on 4/29/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Foundation


class Roll {
	var die: Die
	var result: Int
	
	init(die: Die, result: Int) {
		self.die = die
		self.result = result
	}
	
	func compareTo(anotherRoll: Roll) -> Result {
		let ownerTag = self.die.owner != nil ? "\(self.die.owner!)" : ""
		if self.result > anotherRoll.result {
			print("\(ownerTag): I win! :)")
			return Result.win
		} else if self.result < anotherRoll.result {
			print("\(ownerTag): I lose! :)")
			return Result.loss
		} else {
			print("\(ownerTag): We tied.")
			return Result.tie
		}
	}
}
