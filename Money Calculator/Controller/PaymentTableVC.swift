//
//  PaymentTableVC.swift
//  Money Calculator
//
//  Created by Burak AKCAN on 27.06.2022.
//

import UIKit
import RealmSwift

class PaymentTableVC: UITableViewController,UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var odemeler : List<Odeme>?
    
    
    var selectActivity:Aktivities? {
        didSet{
            payLoad()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return odemeler?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paycell", for: indexPath)
        
        if let odeme = odemeler?[indexPath.row]{
            cell.textLabel?.text = "\(odeme.payName) - \(odeme.price) "
        }else{
            cell.textLabel?.text = "Error"
        }
        
        return cell
    }

    @IBAction func buttonPaymentClick(_ sender: Any) {
        let alert = UIAlertController(title: "Add Persn", message: nil, preferredStyle: .alert)
        alert.addTextField { txt in
            txt.placeholder = "Name"
        }
        alert.addTextField { txt in
            txt.placeholder = "Information"
        }
        alert.addTextField { txt in
            txt.placeholder = "Price"
            txt.keyboardType = .numberPad
            
        }
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let txtName = alert.textFields![0]
            let txtInfo = alert.textFields![1]
            let txtPrice = alert.textFields![2]
            
          
                
                if let selectActivity = self.selectActivity {
                    try! self.realm.write({
                        let newPay = Odeme(payName: txtName.text!, info: txtInfo.text!, price:Int(txtPrice.text!) ?? 0)
                        selectActivity.odemeler.append(newPay)
                    })
                }
            self.tableView.reloadData()
        }
       
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toEdit", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEdit"{
            let editVc = segue.destination as! EditViewController
            
            if let selectIndex = tableView.indexPathForSelectedRow{
                if let seciliOdeme = odemeler?[selectIndex.row]{
                    editVc.secilenOdeme = seciliOdeme
                    editVc.secilenAktivite = selectActivity
                    editVc.title = "\(seciliOdeme.payName) Ödeme Bilgileri"
                }
            }
            
        }
        
    }
    
    
    func payLoad(){
        odemeler = selectActivity?.odemeler
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let secilenOdeme = odemeler?[indexPath.row] {
                do{
                  try  realm.write {
                        realm.delete(secilenOdeme)
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        tableView.reloadData()
    }
  

    
}
