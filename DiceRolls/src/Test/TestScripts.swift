//
//  TestScripts.swift
//  DiceRolls
//
//  Created by Justin Reusch on 5/4/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Foundation

func testScript() {
	let justin = Person(name: "Justin")
	let testDie = Die(sides: [1,2,3,4,5,6], owner: justin)
	print(testDie.identify())
	let testDie2 = Die(sides: [1,2,3,4])
	print(testDie2.identify())
	testDie2.assignOwner(owner: justin)
	print(testDie2.identify())
}
