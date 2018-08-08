//
//  Person.swift
//  DiceRolls
//
//  Created by Justin Reusch on 4/29/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Foundation

class Person {
	var name: Name
	var gender: Gender
	var dice: [Die]
	
	init(name: Name, gender: Gender = .unknown, die: Die? = nil) {
		self.name = name
		self.gender = gender
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
		print("\(self.name.shortName) now owns a die with \(String(die.sideCount)) sides.")
	}
	func identify(type: NameType = .short) -> String {
		let personId: String = self.name.identify(type: type)
		var diceAdder: String
		let numDice: Int = self.dice.count
		if numDice > 1 {
			diceAdder = "I have \(numDice) dice."
		} else if numDice == 1 {
			diceAdder = "I have one die."
		} else {
			diceAdder = ""
		}
		let returnString: String = "\(personId) \(diceAdder)"
		return returnString
	}
}

extension Person: Equatable {
	static func == (lhs: Person, rhs: Person) -> Bool {
		let namesAreEqual = lhs.name.longName == rhs.name.longName
		return namesAreEqual
	}
}

struct Name {
	var first: String
	var middle: String?
	var last: String?
	// Short name is always the first name
	var shortName: String
	// Full name is the first and last (if available)
	var fullName: String
	// Long name is the first, middle and last name (if available)
	var longName: String
	
	init(first: String, middle: String? = nil, last: String? = nil) {
		var isMiddleName: Bool
		var isLastName: Bool
		self.first = first
		if let myMiddleName = middle {
			self.middle = myMiddleName
			isMiddleName = true
		} else {
			self.middle = nil
			isMiddleName = false
		}
		if let myLastName = last {
			self.last = myLastName
			isLastName = true
		} else {
			self.last = nil
			isLastName = false
		}
		self.shortName = first
		if isLastName {
			self.fullName = "\(first) \(last!)"
		} else {
			self.fullName = first
		}
		if isMiddleName && isLastName {
			self.longName = "\(first) \(middle!) \(last!)"
		} else if isMiddleName && !isLastName {
			self.longName = "\(first) \(middle!)"
		} else if isLastName && !isMiddleName {
			self.longName = "\(first) \(last!)"
		} else {
			self.longName = first
		}
	}
	func identify(type: NameType = .short) -> String {
		var returnString: String
		switch type {
			case .short:
				returnString = "My name is \(self.shortName)."
			case .full:
				returnString = "My name is \(self.fullName)."
			case .long:
				returnString = "My name is \(self.longName)."
		}
		return returnString
	}
}

enum NameType {
	case short, full, long
}

enum Gender {
	case male
	case female
	case transgender
	case unknown
}
