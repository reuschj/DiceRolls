//
//  ViewController.swift
//  DiceRolls
//
//  Created by Justin Reusch on 3/27/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	
	var people: [Person]?
	var dice: [Die]?
	var rollResults: MultiRollOutput?
	
	// Actions and Outlets --------------------------------------
	
	//  The text input to set number of times to roll
	@IBOutlet var setTimes: NSTextField!
	
	//  A simple text field for text-only output
	@IBOutlet var outputArea: NSTextFieldCell!
	
	// An NSTableView for dice to roll
	@IBOutlet weak var diceToRollList: NSTableView!
	
	//  An NSTableView for roll results
	@IBOutlet weak var resultsTable: NSTableView!
	
	//  A first test that ouputs to the simple text feild
	@IBAction func rollButton(_ sender: NSButton) {
		var diceToRoll: [Die] = []
		for die in dice! {
			if die.selected {
				diceToRoll.append(die)
			}
		}
		self.rollResults = performRolls(dice: diceToRoll, times: setTimes)
		resultsTable.reloadData()
		print(self.rollResults!.reportString)
	}
	
	//  Connects checkbox state with dice selection
	@objc
	@IBAction func changeCheckbox(_ sender: NSButton) {
		if let diceList = dice {
			for (index, die) in diceList.enumerated() {
				if let id = sender.identifier {
					let idValue = id.rawValue
					if idValue == "Check" + String(index) {
						if sender.state == .on {
							die.select()
						} else {
							die.deselect()
						}
					}
				}
			}
		}
	}
	
	// View Did Load --------------------------------------
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		// Make people and dice and load to view controller
		let (people, dice) = makePeopleAndDice()
		(self.people, self.dice) = (people, dice)
		// Make initial roll and append to view controller
		self.rollResults = performRolls(dice: self.dice!, times: setTimes)
		
		// Set data source and delegate for dice list
		diceToRollList.dataSource = self
		diceToRollList.delegate = self
		
		// Set data source and delegate for result table
		resultsTable.dataSource = self
		resultsTable.delegate = self
	}
	
	// Did Set --------------------------------------
	
	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}
	
	// Functions --------------------------------------
	
	func makePeopleAndDice() -> ([Person], [Die]) {
		// Make a few people
		var people = [Person]()
		let Katherine = Person(name: Name(first: "Katherine"))
		let Zack = Person(name: Name(first: "Zack"))
		let Justin = Person(name: Name(first: "Justin", middle: "Alexander", last: "Reusch"), gender: .male)
		let Hang = Person(name: Name(first: "Hang", last: "Reusch"), gender: .female)
		people.append(Katherine)
		people.append(Zack)
		people.append(Justin)
		people.append(Hang)
		
		// Make the dice
		var dice = [Die]()
		dice.append(Die(sides: [3,3,3,3,3,6], owner: Katherine))
		dice.append(Die(sides: [2,2,2,5,5,5], owner: Zack))
		dice.append(Die(sides: [3,3,3,3,3,6], owner: Justin))
		dice.append(Die(sides: [2,2,2,5,5,5], owner: Hang))
		dice.append(Die(sides: [1,2,3,4,5,6], owner: Justin))
		dice.append(Die(sides: [1,2,3,4,5,6], owner: Hang))
		
		return (people, dice)
	}
	
	func performRolls (dice: [Die], times timesInput: NSTextField) -> MultiRollOutput {
		var numTimesToRoll: UInt = 100
		let currentInput: UInt = UInt(abs(timesInput.intValue))
		let currentInputIsValid = !Float(currentInput).isNaN && currentInput > 0 && String(currentInput) != ""
		if currentInputIsValid {
			numTimesToRoll = currentInput
		}
		let result = rollXTimes(timesToRoll: numTimesToRoll, listOfDiceToRoll: dice)
		timesInput.stringValue = String(numTimesToRoll)
		return result
	}
	
}


// Extention: Table Data Source --------------------------------------

extension ViewController: NSTableViewDataSource {
	func numberOfRows(in tableView: NSTableView) -> Int {
		return rollResults?.results.count ?? 0
	}
}


// Extention: Table Delegate --------------------------------------

extension ViewController: NSTableViewDelegate {
	
	fileprivate enum CellIdentifiers {
		static let DieListNameCell = "DieListNameCellID"
		static let DieNameCell = "DieNameCellID"
		static let ScoreCell = "ScoreCellID"
		static let WinsCell = "WinsCellID"
		static let TiesCell = "TiesCellID"
		static let LossesCell = "LossesCellID"
		static let OtherCell = "OtherCellID"
		static let Check = "Check"
	}
	
	// Build table views
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		// Build List of Dice to Roll
		if tableView == self.diceToRollList {
			var cellText: String = ""
			var cellIdentifier: String = ""
			
			guard let thisDie: Die? = dice?[row] else {
				return nil
			}
			
			let dieColumn = tableView.tableColumns[0]
			
			switch tableColumn {
			case dieColumn:
				if let die = thisDie {
					cellText = die.name
					cellIdentifier = CellIdentifiers.Check + String(row)
				}
			default:
				cellText = ""
				cellIdentifier = ""
			}
			
			let identifier = NSUserInterfaceItemIdentifier(cellIdentifier)
		
			var dieState: Bool
			if let die = thisDie {
				dieState = die.selected
			} else {
				dieState = true
			}
			
			let checkBox = NSButton()
			checkBox.identifier = identifier
			checkBox.state = dieState ? .on : .off
			checkBox.setButtonType(.`switch`)
			checkBox.title = cellText
			checkBox.alignment = .left
			checkBox.action = #selector(changeCheckbox(_:))
			return checkBox
			
		}
		
		// Build Results Table
		if tableView == self.resultsTable {
			var cellText: String = ""
			var cellIdentifier: String = ""
			
			guard let result = rollResults?.results[row] else {
				return nil
			}
			
			let dieColumn = tableView.tableColumns[0]
			let scoreColumn = tableView.tableColumns[1]
			let winsColumn = tableView.tableColumns[2]
			let tiesColumn = tableView.tableColumns[3]
			let lossesColumn = tableView.tableColumns[4]
			let otherColumn = tableView.tableColumns[5]
			
			func generateCellText (_ result: Int, _ percent: Double) -> String {
				return "\(String(result))\t(\(percentageString(input: percent)))"
			}
			
			switch tableColumn {
			case dieColumn:
				cellText = result.die.name
				cellIdentifier = CellIdentifiers.DieNameCell
			case scoreColumn:
				cellText = String(result.totalScore)
				cellIdentifier = CellIdentifiers.ScoreCell
			case winsColumn:
				cellText = generateCellText(result.win, result.winPercent)
				cellIdentifier = CellIdentifiers.WinsCell
			case tiesColumn:
				cellText = generateCellText(result.tie, result.tiePercent)
				cellIdentifier = CellIdentifiers.TiesCell
			case lossesColumn:
				cellText = generateCellText(result.loss, result.lossPercent)
				cellIdentifier = CellIdentifiers.LossesCell
			case otherColumn:
				cellText = generateCellText(result.none, result.nonePercent)
				cellIdentifier = CellIdentifiers.OtherCell
			default:
				cellText = ""
				cellIdentifier = ""
			}
			
			let identifier = NSUserInterfaceItemIdentifier(cellIdentifier)
			
			if let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView {
				cell.textField?.stringValue = cellText
				return cell
			}
		}
		
		return nil
		
	}
}


