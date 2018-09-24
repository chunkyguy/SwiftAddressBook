//
//  SwiftAddressBookTests.swift
//  SwiftAddressBookTests
//
//  Created by Albert Bori on 2/23/15.
//  Copyright (c) 2015 socialbit. All rights reserved.
//

import UIKit
import XCTest
import SwiftAddressBook
import AddressBook

//**** Run the example project first, to accept address book access ****
class SwiftAddressBookTests: XCTestCase {

	let accessError = "Address book access was not granted. Run the main application and grant access to the address book."
	let accessErrorNil = "Failed to get address book access denial error"

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	//TODO: test authorization status, save, revert

	func testGetAllPeople() {

		if (swiftAddressBook == nil) {
			XCTAssertNotNil(swiftAddressBook, self.accessErrorNil)
			return
		}

		let people : Array<SwiftAddressBookPerson>? = swiftAddressBook?.allPeople

        XCTAssert((people?.count)! > 0, "Unable to get people from address book")	}

	//TODO: tests badly: actually only checks that array is not empty, instead of if linked contacts contained
	func testGetAllPeopleExcludingLinkedContacts() {

		if (swiftAddressBook == nil) {
			XCTAssertNotNil(swiftAddressBook, self.accessErrorNil)
			return
		}

		let people : Array<SwiftAddressBookPerson>? = swiftAddressBook?.allPeopleExcludingLinkedContacts

        XCTAssert((people?.count)! > 0, "Unable to get main contacts from address book")
	}


	//MARK: - Helper funtions

	func getDateTimestamp() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        return formatter.string(from: Date())
	}

	func getDate(year: Int,_ month: Int,_ day: Int) -> Date {
        var components = DateComponents()
		components.year = year
		components.month = month
		components.day = day
        return Calendar.current.date(from: components)!
	}
}
