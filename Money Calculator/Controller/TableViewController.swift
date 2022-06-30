//
//  TableViewController.swift
//  Money Calculator
//
//  Created by Burak AKCAN on 26.06.2022.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController,UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var aktiviteListesi : Results<Aktivities>?
  
    //For Realm
    
    let realm = try! Realm()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAktivity))
        //Drop Button custom
        setMore()
        searchBar.delegate = self
        
        
        getData()
       // print(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
  
    
    func setMore(){
        let actionAdd = UIAction(title: "Add", image: .add, identifier: nil, discoverabilityTitle: nil, attributes:.destructive, state: .mixed) { action in
            print("action add")
        }
        let menu = UIMenu(title: "", image:.checkmark, identifier:.text, options: .destructive, children: [actionAdd])
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil, image:.actions, primaryAction: nil, menu: menu)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return aktiviteListesi?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        let sonuc:Int = aktiviteListesi?[indexPath.row].odemeler.sum(ofProperty: "price") ?? 0
  cell.textLabel?.text = "\( aktiviteListesi?[indexPath.row].name ?? ""  ) - \(sonuc) "
       
        if aktiviteListesi?[indexPath.row].isActive ?? false{
            cell.accessoryType = .checkmark
            cell.backgroundColor = .darkGray
        }else{
            cell.accessoryType = .none
        }
        
        
        return cell
    }
     
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let selectCell = tableView.cellForRow(at: indexPath)
        
     //   activities[indexPath.row].isActive = !activities[indexPath.row].isActive
     //     saveData()
     //   tableView.reloadData()
        
        
        performSegue(withIdentifier: "toPayment", sender: nil)
        
        
//        if selectCell?.accessoryType == UITableViewCell.AccessoryType.checkmark {
//            selectCell?.accessoryType = .none
//        }else{
//            selectCell?.accessoryType = .checkmark
//        }
    }
//    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPayment"{
            let paymentVC = segue.destination as! PaymentTableVC
            
            if let selectIndex = tableView.indexPathForSelectedRow{
                paymentVC.selectActivity = aktiviteListesi?[selectIndex.row]
            }
        }
    }
   

}

extension TableViewController{
    @objc func addAktivity(){
        let ac = UIAlertController(title: "Add Aktivity", message: nil, preferredStyle: .alert)
        
        ac.addTextField { txt in
            txt.placeholder = "Aktivity Name"
            
        }
        
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        let acAction = UIAlertAction(title: "Add", style: .default) { action in
            let txtActivity = ac.textFields![0]
            
            if ((txtActivity.text?.isEmpty) == false){
                let activite = Aktivities()
                activite.name = txtActivity.text!
                
                self.saveData(aktivite: activite)
                self.tableView.reloadData()
            }
            
        }
        ac.addAction(cancel)
        ac.addAction(acAction)
        present(ac, animated: true)
        
    }
    func saveData(aktivite:Aktivities){
        do{
            try realm.write({
                realm.add(aktivite)
            })
        }catch{
            print(error.localizedDescription)
        }
        
    }
    func getData(){
        aktiviteListesi = realm.objects(Aktivities.self)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if let seletActivite = aktiviteListesi?[indexPath.row]{
//            do{
//                try realm.write({
////Burası onemli öncelikle alt verilerimi silmem gerek!!!
//                    realm.delete(seletActivite.odemeler)
////Eğer sadece aktivitelerisilecek olursam onun odemeleri kalacaktır bu yüzde önce ödemeler sonra aktivite silnmeli
//                    realm.delete(seletActivite)
//                })
//            }catch{
//                print(error.localizedDescription)
//            }
//        }
//        tableView.reloadData()
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let silme = UITableViewRowAction(style: .default, title: "Sil") { action, index in
            if let seletActivite = self.aktiviteListesi?[indexPath.row]{
                do{
                    try self.realm.write({
    //Burası onemli öncelikle alt verilerimi silmem gerek!!!
                        self.realm.delete(seletActivite.odemeler)
    //Eğer sadece aktivitelerisilecek olursam onun odemeleri kalacaktır bu yüzde önce ödemeler sonra aktivite silnmeli
                        self.realm.delete(seletActivite)
                    })
                }catch{
                    print(error.localizedDescription)
                }
            }
            tableView.reloadData()
        }
        
        let odesme = UITableViewRowAction(style: .normal, title: "Ödeştik") { action, index in
            if let aktivite = self.aktiviteListesi?[indexPath.row]{
                do{
                    try self.realm.write({
                        aktivite.isActive = true
                    })
                }catch{
                    print(error.localizedDescription)
                }
            }
            self.tableView.reloadData()
        }
        odesme.backgroundColor = .green
        return [odesme,silme]
        
    }
    
    
//Filtre
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      aktiviteListesi = aktiviteListesi?.filter("name CONTAINS[cd] %@ ", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
  
        tableView.reloadData()
    }
//Search bar içerisindeki text değiştiğinde çalışan metot
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if aktiviteListesi?.count == 0 {
            getData() // Liste boşalırsa tekrar çağır verileri
            tableView.reloadData()
        }
        
        if searchBar.text?.count == 0{
            getData() //Verileri geri getirir
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()// kullanıcı tüm değerleri sildiğinde klavye kapanacak
                
            }
        }
    }
}


