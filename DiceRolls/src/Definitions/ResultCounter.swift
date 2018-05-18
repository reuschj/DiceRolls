//
//  ResultCounter.swift
//  DiceRolls
//
//  Created by Justin Reusch on 5/6/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Foundation

struct ResultCounter {
	let die: Die
	var win: Int = 0
	var tie: Int = 0
	var none: Int = 0
	var loss: Int = 0
	var results = [Result]()
	var totalScore: Int = 0
	var winPercent: Double = 0.0
	var tiePercent: Double = 0.0
	var nonePercent: Double = 0.0
	var lossPercent: Double = 0.0
	
	init(die: Die) {
		self.die = die
	}
	
	//sum(result.value for result in self.results)
	func findTotalScore(results: [Result]) -> Int {
		var total: Int = 0
		for result in results {
			total += result.rawValue
		}
		let totalScore: Int = total
		return totalScore
	}
	
	func getPercent(valueToGet: Int, results: [Result]) -> Double {
		return Double(valueToGet) / Double(results.count)
	}
	
	mutating func reset() {
		self.win = 0
		self.tie = 0
		self.none = 0
		self.loss = 0
		self.results.removeAll()
		self.totalScore = 0
		self.winPercent = 0.0
		self.tiePercent = 0.0
		self.nonePercent = 0.0
		self.lossPercent = 0.0
	}
	
	mutating func calculateProperties() {
		self.totalScore = findTotalScore(results: self.results)
		self.winPercent = getPercent(valueToGet: self.win, results: self.results)
		self.tiePercent = getPercent(valueToGet: self.tie, results: self.results)
		self.nonePercent = getPercent(valueToGet: self.none, results: self.results)
		self.lossPercent = getPercent(valueToGet: self.loss, results: self.results)
	}
	
	mutating func addWin(_ amount: Int = 1) {
		self.win += amount
		self.results.append(Result.win)
		self.calculateProperties()
	}
	
	mutating func addTie(_ amount: Int = 1) {
		self.tie += amount
		self.results.append(Result.tie)
		self.calculateProperties()
	}
	
	mutating func addNone(_ amount: Int = 1) {
		self.none += amount
		self.results.append(Result.none)
		self.calculateProperties()
	}
	
	mutating func addLoss(_ amount: Int = 1) {
		self.loss += amount
		self.results.append(Result.loss)
		self.calculateProperties()
	}
}
