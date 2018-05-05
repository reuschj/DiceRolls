//
//  RollGroup.swift
//  DiceRolls
//
//  Created by Justin Reusch on 4/29/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Foundation

class RollGroup {
	var rolls: [Roll]
	let rollCount: Int
	let winningResult: Int
	let runnerUpResult: Int
	let losingResult: Int
	var winners: [(Roll, Die, Person)]
	var runnersUp: [(Roll, Die, Person)]
	var losers: [(Roll, Die, Person)]
	
	init(listOfRolls: [Roll]) {
		self.rolls = listOfRolls.sorted(by: {$0.result > $1.result})
		self.rollCount = listOfRolls.count
		//
		var currentIndex: Int = 0
		let indexIsStillInRange = currentIndex < self.rollCount - 1 && currentIndex >= 0
		let currentResultEqualsNextResult = self.rolls[currentIndex].result == self.rolls[currentIndex + 1].result
		let currentResultEqualsPreviousResult = self.rolls[currentIndex].result == self.rolls[currentIndex - 1].result
		// Let's make a list of winners
		self.winningResult = self.rolls[currentIndex].result
		var winnerList: [Roll] = [self.rolls[currentIndex]]
		while indexIsStillInRange && currentResultEqualsNextResult {
			currentIndex += 1
			winnerList.append(self.rolls[currentIndex])
		}
		// Let's make a list of runners up
		var runnerUpList: [Roll]
		if indexIsStillInRange {
			currentIndex += 1
			self.runnerUpResult = self.rolls[currentIndex].result
			runnerUpList = [self.rolls[currentIndex]]
			while indexIsStillInRange && currentResultEqualsNextResult {
				currentIndex += 1
				runnerUpList.append(self.rolls[currentIndex])
			}
		} else {
			// If we don't have any runners up, the runner up result is the same as the winning result
			self.runnerUpResult = self.winningResult
			runnerUpList = []
		}
		// Let's make a list of last-place results
		var loserList: [Roll]
		currentIndex = Int(listOfRolls.count - 1)
		self.losingResult = self.rolls[currentIndex].result
		loserList = [self.rolls[currentIndex]]
		while indexIsStillInRange && currentResultEqualsPreviousResult {
			currentIndex -= 1
			loserList.append(self.rolls[currentIndex])
		}
		// Winners
		self.winners = []
		for winner in winnerList {
			self.winners.append((winner, winner.die, winner.die.owner!))
		}
		// Runners Up
		self.runnersUp = []
		for runnerUp in runnerUpList {
			self.runnersUp.append((runnerUp, runnerUp.die, runnerUp.die.owner!))
		}
		// Last Place
		self.losers = []
		for loser in loserList {
			self.losers.append((loser, loser.die, loser.die.owner!))
		}
	}
}
