//
//  Person.swift
//  DiceRolls
//
//  Created by Justin Reusch on 4/29/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Foundation

class Person {
	var name: String
	var dice: [Die]
	
	init(name: String, die: Die? = nil) {
		self.name = name
		if let possibleDie = die {
			self.dice = [possibleDie]
			possibleDie.owner = self
		} else {
			self.dice = []
		}
	}
	func assignDie(die: Die) {
		self.dice.append(die)
		die.owner = self
		print("\(self.name) now owns a die with \(String(die.sideCount)) sides.")
	}
}
