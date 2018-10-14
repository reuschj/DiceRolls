//
//  SimpleRedux.swift
//  DiceRolls
//
//  Created by Justin Reusch on 3/28/18.
//  Copyright © 2018 Justin Reusch. All rights reserved.
//

import Foundation

protocol Action { }

protocol State { }

typealias Reducer = (_ action: Action, _ state: State?) -> State

protocol StoreSubscriber {
	func newState(state: State)
}

class Store {
	let reducer: Reducer
	var state: State?
	var subscribers: [StoreSubscriber] = []
	
	init(reducer: @escaping Reducer, state: State?) {
		self.reducer = reducer
		self.state = state
	}
	
	func dispatch(action: Action) {
		state = reducer(action, state)
		
		subscribers.forEach { $0.newState(state: state!) }
	}
	
	func subscribe(_ newSubscriber: StoreSubscriber) {
		subscribers.append(newSubscriber)
	}
}
