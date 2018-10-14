//
//  RollXTimes.swift
//  DiceRolls
//
//  Created by Justin Reusch on 5/6/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Foundation

func rollXTimes(timesToRoll: UInt, listOfDiceToRoll: [Die], showAllResults: Bool = false) -> MultiRollOutput {
	var resultCounters = [String: ResultCounter]()
	for die in listOfDiceToRoll {
		let dieLookup = die.id
		resultCounters[dieLookup] = ResultCounter(die: die)
	}
	var allRollGroups = [RollGroup]()
	var actualTimesToRoll = timesToRoll
	if timesToRoll < 1 {
		actualTimesToRoll = 1
	}
	for _ in 1...actualTimesToRoll {
		var thisRollGroup = [Roll]()
		for die in listOfDiceToRoll {
			let theCurrentRoll = die.roll()
			thisRollGroup.append(theCurrentRoll)
		}
		allRollGroups.append(RollGroup(listOfRolls: thisRollGroup))
	}
	for (index, thisRollGroup) in allRollGroups.enumerated() {
		if showAllResults {
			print("Roll \(index + 1)")
			print(thisRollGroup)
		}
		let winners = thisRollGroup.winners
		let thereWasOnlyOneWinner: Bool = winners.count == 1 ? true : false
		for winner in winners {
			let dieID = winner.die.id
			if thereWasOnlyOneWinner {
				// There was a single winner (count as win)
				resultCounters[dieID]?.addWin()
			} else {
				// There were multiple winners (count as ties)
				resultCounters[dieID]?.addTie()
			}
		}
		let losers = thisRollGroup.losers
		let thereWasOnlyOneLoser: Bool = losers.count == 1 ? true : false
		for loser in losers {
			let dieID = loser.die.id
			if thereWasOnlyOneLoser {
				resultCounters[dieID]?.addLoss()
			}
		}
		let runnersUp = thisRollGroup.runnersUp
		let noResults = thisRollGroup.noResults
		// For this excersize, we the runners up will count as no result
		let allNone = runnersUp.union(noResults)
		for none in allNone {
			let dieID = none.die.id
			resultCounters[dieID]?.addNone()
		}
	}
	var resultsToSort = [ResultCounter]()
	for (_, value) in resultCounters {
		resultsToSort.append(value)
	}
	let sortedResults = resultsToSort.sorted(by: {$0.totalScore > $1.totalScore})
	return MultiRollOutput(results: sortedResults)
}
