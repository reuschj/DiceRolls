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
	var winners = Set<Roll>()
	var runnersUp = Set<Roll>()
	var losers = Set<Roll>()
  var noResults = Set<Roll>()
	
	init(listOfRolls: [Roll]) {
		self.rolls = listOfRolls.sorted(by: {$0.result > $1.result})
		self.rollCount = listOfRolls.count
		let rolls = self.rolls
    // Find the high, low and runner-up values
    var highValue = rolls[0].result
    var secondHighValue = rolls[0].result
    var lowValue = rolls[0].result
    // Find just high and low on the first pass
    for roll in rolls {
      let currentValue = roll.result
      if currentValue > highValue {
        highValue = currentValue
      }
      if currentValue < lowValue {
        lowValue = currentValue
      }
    }
    // Use a second pass to find the runner-up
    for roll in rolls {
      let currentValue = roll.result
      if currentValue > secondHighValue && currentValue < highValue {
        secondHighValue = currentValue
      }
    }
    self.winningResult = highValue
    self.runnerUpResult = secondHighValue
    self.losingResult = lowValue
    // Assign each value to the correct set
    for roll in rolls {
      let currentValue = roll.result
      if currentValue == highValue {
        self.winners.insert(roll)
      } else if currentValue == secondHighValue {
        self.runnersUp.insert(roll)
      } else if currentValue == lowValue {
        self.losers.insert(roll)
      } else {
        self.noResults.insert(roll)
      }
    }
		// If there is more than one loser, we can move the rolls to noResult list
    let thereIsMoreThanOneLoser = self.losers.count > 1
    if thereIsMoreThanOneLoser {
      for loser in self.losers {
        self.losers.remove(loser)
        self.noResults.insert(loser)
      }
    }
	}
}
