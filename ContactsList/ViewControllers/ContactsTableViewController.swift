//
//  ContactsTableViewController.swift
//  ContactsList
//
//  Created by Andrey Khakimov on 06.12.2021.
//

import UIKit
import Kingfisher

class ContactsTableViewController: UITableViewController {
    
    let contactsNetworkManager = ContactsNetworkManager()
    
    var contacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(with: 100)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customContact", for: indexPath) as! ContactTableViewCell
        let contact = contacts[indexPath.row]
        let imageURL = URL(string: contact.picture.large)!
        cell.configure(image: imageURL, name: contact.name.fullname)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let detailVC = segue.destination as? DetailInfoViewController else { return }
        let contact = contacts[indexPath.row]
        detailVC.contact = contact
    }
    
    private func fetchData(with personNumber: Int) {
        contactsNetworkManager.getContacts(
            count: personNumber,
            completion: { [weak self] contacts in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.contacts = contacts ?? []
                    self.tableView.reloadData()
                }
            }
        )
        //        networkManager.sendRequest(endpoint: .numberOfPersons(personNumber)) { [weak self] (contact: ContactsResponse?) in
        //            DispatchQueue.main.async {
        //                guard let self = self else { return }
        //                self.contacts = contact?.results ?? []
        //                self.tableView.reloadData()
        //            }
        //        }
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
