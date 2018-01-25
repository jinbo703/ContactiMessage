//
//  ContactsController.swift
//  ContactiMessage
//
//  Created by John Nik on 12/6/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Contacts
import Messages
import MessageUI

class ContactsController: UITableViewController {
    
    let cellId = "cellId"
    
    var friendsArray = [Friends]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchContacts()
        
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
    }
    
}

//MARK: handle invite
extension ContactsController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
    func handleInvite(cell: UITableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let contact = friendsArray[indexPath.section].friends[indexPath.row]
        
        print(contact)
        
        let fullName = contact.givenName + " " + contact.familyName
        let urlToShare = "http://www.clarifydesigns.com"
        
        let messageController = MFMessageComposeViewController()
        messageController.body = fullName + ", put this on your phone so I can meet and chat you anywhere, anytime. \(urlToShare)"
        messageController.recipients = [fullName]
        messageController.messageComposeDelegate = self
        
        self.present(messageController, animated: true, completion: nil)
        
    }
    
}

//MARK: handle contact
extension ContactsController {
    fileprivate func fetchContacts() {
        
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Failed to request access: ", err)
                return
            }
            
            if granted {
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    
                    
                    var contacts = [CNContact]()
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouwantToStopEnumerating) in
                        
                        contacts.append(contact)
                        
                    })
                    
                    let inviteFriends = Friends(isExpanded: true, friends: contacts)
                    //                    let invitedFriends = Friends(isExpanded: true, friends: [])
                    self.friendsArray = [inviteFriends]
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    
                } catch let err {
                    print("failed to enumerate contacts: ", err)
                }
                
            } else {
                
            }
        }
    }
    
    @objc fileprivate func handleExpandClose(button: UIButton) {
        
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        
        for row in friendsArray[section].friends.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = friendsArray[section].isExpanded
        friendsArray[section].isExpanded = !isExpanded
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        
    }
}

//MARK: handle tableview
extension ContactsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !friendsArray[section].isExpanded {
            return 0
        }
        return friendsArray[section].friends.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        
        cell.contactsController = self
        
        let contact = friendsArray[indexPath.section].friends[indexPath.row]
        cell.contact = contact
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button = UIButton(type: .system)
        
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        if section == 0 {
            button.setTitle("Invited Friends", for: .normal)
        } else {
            button.setTitle("Invite Friends", for: .normal)
        }
        button.tag = section
        
        return button
    }
    
}

















