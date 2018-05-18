//
//  TestScripts.swift
//  DiceRolls
//
//  Created by Justin Reusch on 5/4/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Foundation

func testScript() {
	
	// Make a few people
	let Katherine = Person(name: Name(first: "Katherine"))
	let Zack = Person(name: Name(first: "Zack"))
	let Justin = Person(name: Name(first: "Justin", middle: "Alexander", last: "Reusch"), gender: .male)
	let Hang = Person(name: Name(first: "Hang", last: "Reusch"), gender: .female)
	
	// Make the dice
	var dice = [Die]()
	dice.append(Die(sides: [3,3,3,3,3,6], owner: Katherine))
	dice.append(Die(sides: [2,2,2,5,5,5], owner: Zack))
	dice.append(Die(sides: [3,3,3,3,3,6], owner: Justin))
	dice.append(Die(sides: [2,2,2,5,5,5], owner: Hang))
	dice.append(Die(sides: [1,2,3,4,5,6], owner: Justin))
	dice.append(Die(sides: [1,2,3,4,5,6], owner: Hang))
	
	
	// Roll each die in dice
	var rolls = [Roll]()
	for die in dice {
		rolls.append(die.roll())
	}
	
	print("--------------------")
	
	// Introduce people
	print("Introducing...")
	print(Katherine.identify())
	print(Zack.identify())
	print(Justin.identify())
	print(Hang.identify())
	print("--------------------")
	
	// Print a few single rolls
	print("Let's roll 2 dice...")
	print(rolls[0].report())
	print(rolls[1].report())
	// Let's compare them...
	_ = rolls[0].compareTo(rolls[1])
	print("--------------------")
	
	print("Let's roll 2 more...")
	print(rolls[4].report())
	print(rolls[5].report())
	// Let's compare them...
	_ = rolls[4].compareTo(rolls[5])
	_ = rolls[5].compareTo(rolls[4])
	print("--------------------")
	
	// A few more tests
	let testDie = Die(sides: [1,2,3,4,5,6], owner: Justin)
	print(testDie.identify())
	let testDie2 = Die(sides: [1,2,3,4])
	print(testDie2.identify())
	testDie2.assignOwner(owner: Justin)
	print(testDie2.identify())
	print("--------------------")
	
	// Roll the first 4 dice 10 times, printing each roll result
	print("Rolling 10 times...")
	let output01 = rollXTimes(timesToRoll: 10, listOfDiceToRoll: [dice[0], dice[1], dice[2], dice[3]], showAllResults: false)
	print(output01.reportString)
	print("--------------------")
	
	// Roll just dice 1 and 2 the inputed amount of times
	let output02 = rollXTimes(timesToRoll: 100, listOfDiceToRoll: [dice[0], dice[1]], showAllResults: false)
	print(output02.reportString)
	print("--------------------")
	
	// Roll just dice 1, 2, 5 and 6 the inputed amount of times
	let output03 = rollXTimes(timesToRoll: 100, listOfDiceToRoll: [dice[0], dice[1], dice[4], dice[5]], showAllResults: false)
	print(output03.reportString)
	print("--------------------")
	
}
