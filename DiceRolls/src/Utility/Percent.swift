//
//  Percent.swift
//  DiceRolls
//
//  Created by Justin Reusch on 5/14/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Foundation

func percentageString(input decimalInput: Double) -> String {
	let convertedInput = Int(round(decimalInput * 100))
	return "\(String(convertedInput))%"
}
