//
//  MultiRollOutput.swift
//  DiceRolls
//
//  Created by Justin Reusch on 5/17/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Foundation

struct MultiRollOutput {
	let reportString: String
	let results: [ResultCounter]
	
	init(results: [ResultCounter]) {
		self.results = results
		let count = results[0].results.count
		let winner = results[0].die.name
		var returnString = "After \(count) rolls, the winner is: \(winner)"
		for result in results {
			returnString += "\nScore: \(result.totalScore) | Wins: \(result.win) (\(percentageString(input: result.winPercent))) | Ties: \(result.tie) (\(percentageString(input: result.tiePercent))) | Losses: \(result.loss) (\(percentageString(input: result.lossPercent))) | Other: \(result.none) (\(percentageString(input: result.nonePercent))) <- (\(result.die.name))"
		}
		self.reportString = returnString
	}
}
