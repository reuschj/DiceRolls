//
//  StringBuilding.swift
//  DiceRolls
//
//  Created by Justin Reusch on 4/4/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Foundation

// Takes a list of integers and outputs a string description
func buildListToString<T: CustomStringConvertible>(_ inputList: [T]) -> String {
	var outputString = ""
	for (index, value) in inputList.enumerated() {
		if index != 0 && index == inputList.count - 1 {
			outputString += " and "
		} else if index != 0 && index != inputList.count - 1 {
			outputString += ", "
		}
		outputString += value.description
	}
	return outputString
}
