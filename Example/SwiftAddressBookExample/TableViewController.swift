//
//  TableViewController.swift
//  Test
//
//  Created by Socialbit - Tassilo Karge on 14.02.15.
//  Copyright (c) 2015 socialbit. All rights reserved.
//

import UIKit
import SwiftAddressBook
import AddressBook

class TableViewController: UITableViewController {


	var groups : [SwiftAddressBookGroup]?
	var people : [SwiftAddressBookPerson]?
	var names : [String?]? = []
	var numbers : [Array<String?>?]? = []
	var birthdates : [Date?]? = []

	override func viewDidLoad() {
		super.viewDidLoad()

		SwiftAddressBook.requestAccessWithCompletion { (b :Bool, _ :CFError?) -> Void in
			if b {

				//TODO: COMMENT IN IF YOU ARE NOT RUNNING UNIT TESTS
				//self.saveObjectsForTableView()

				//TODO: to test adding a new person uncomment the following
				//self.addNewPerson()

				//TODO: to test adding a new group uncomment the following
				//self.addNewGroup()
                DispatchQueue.main.async {
					self.tableView.reloadData()
				}

			}
		}
	}

	func addNewPerson() {
		let person = SwiftAddressBookPerson.create()
		person.firstName = "newTestuserFirstname"
		person.lastName = "newTestuserLastname"
		person.organization = "newTestuserCompanyname"

		let phone = MultivalueEntry(value: "newTestuserNumber", label: "mobile", id: 1)
		person.phoneNumbers = [phone]

        var addresses: [MultivalueEntry<[SwiftAddressBookAddressProperty:Any]>]? = nil
        let address1: [SwiftAddressBookAddressProperty:Any] = [.street:"testStreet", .city:"testCity"]
        let address2: [SwiftAddressBookAddressProperty:Any] = [.street:"testStreet2", .city:"testCity2"]
		addresses = [
			MultivalueEntry(value: address1, label: kABWorkLabel as String?, id: 0),
			MultivalueEntry(value: address2, label: kABHomeLabel as String?, id: 0)
		]
		person.addresses = addresses as? [MultivalueEntry<[SwiftAddressBookAddressProperty:AnyObject]>]

		swiftAddressBook?.addRecord(person)
		swiftAddressBook?.save()
	}

	func addNewGroup() {
		let group = SwiftAddressBookGroup.create()

		group.name = "Testgroup"

		swiftAddressBook?.addRecord(group)

		//it is necessary to save before adding people
		swiftAddressBook?.save()

		//add half of the people
		for i in 0..<self.people!.count/2 {
			group.addMember(self.people![i])
		}

		swiftAddressBook?.save()
	}

	func saveObjectsForTableView() {

		people = swiftAddressBook?.allPeople
		groups = []

		let sources = swiftAddressBook?.allSources
		for source in sources! {
			//println("\(source.sourceName)") //TODO: This throws an exception
			let newGroups = swiftAddressBook!.allGroupsInSource(source)!
			self.groups = self.groups! + newGroups
		}

		self.numbers = self.people?.map { (p) -> (Array<String?>?) in
			return p.phoneNumbers?.map { return $0.value }
		}
		self.names = self.people?.map { (p) -> (String?) in
			return p.compositeName
		}
		self.birthdates = self.people?.map { (p) -> (Date?) in
			return p.birthday
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
		return groups == nil ? 1 : groups!.count+1
	}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if groups == nil || section == groups?.count {
			return people == nil ? 0 : people!.count
		}
		else {
			if let members = groups![section].allMembers {
				return members.count
			}
			else {
				return 0
			}
		}
	}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressViewCell

		if groups == nil || indexPath.section == groups?.count {
			// Configure the cell...
			cell.nameLabel.text = people![indexPath.row].compositeName
			cell.birthdateLabel.text = birthdates![indexPath.row]?.description
			cell.phoneNumberLabel.text = numbers![indexPath.row]?.first!
		}
		else {
			let group = groups![indexPath.section]
			let member = group.allMembers![indexPath.row]
			let name = member.compositeName
			cell.nameLabel.text = name
		}

		return cell
	}

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if groups == nil || section == groups?.count {
			return "All people"
		}
		else {
			return groups![section].name
		}
	}

}
