//
//  ContactCell.swift
//  Contacts
//
//  Created by John Nik on 11/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Contacts

class ContactCell: UITableViewCell {
    
    var contact: CNContact? {
        
        didSet {
            
            guard let contact = contact else { return }
            self.textLabel?.text = contact.givenName + " " + contact.familyName
            self.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            
            self.detailTextLabel?.text = contact.phoneNumbers.first?.value.stringValue
            
        }
        
    }
    
    var contactsController: ContactsController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        
        let starButton = UIButton(type: .system)
        starButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        starButton.setTitle("Invite", for: .normal)
        starButton.tintColor = .red
        starButton.addTarget(self, action: #selector(handleInvite), for: .touchUpInside)
        
        accessoryView = starButton
        
    }
    
    @objc private func handleInvite() {
        
        contactsController?.handleInvite(cell: self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
