//
//  EditViewController.swift
//  Money Calculator
//
//  Created by Burak AKCAN on 30.06.2022.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {
    var secilenOdeme : Odeme?
    let realm = try! Realm()
    var secilenAktivite :Aktivities?
    
    
    @IBOutlet weak var labelToplamOdeme: UILabel!
    @IBOutlet weak var labelAktiviteAdi: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtInfo: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecog = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecog)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setView()
    }
    
    @IBAction func updateClick(_ sender: UIButton) {
//Realm da herhangi bir güncelleme işlemi yok refarens tipten olduğu için classlar bu property deki değişklik realmda da update edilecektir
//Yani Odeme claasından türetilmiş bir nesnenin Realm.write kodları içersinde güncelleme işlemi oldğundan dynamic olarak tanımlandığı için yeni değer realm tarafında da atanacaktır
        if let secilenOdeme = secilenOdeme {
            do{
                try realm.write({
                    secilenOdeme.payName = txtName.text!
                    secilenOdeme.info = txtInfo.text!
                    secilenOdeme.price = Int(txtPrice.text!) ?? 0
                })
                navigationController?.popViewController(animated: true)
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func setView(){
        txtName.text = secilenOdeme?.payName
        txtInfo.text = secilenOdeme?.info
        txtPrice.text = "\(secilenOdeme!.price)"
        
        labelAktiviteAdi.text = "Aktivite Adı \(secilenAktivite!.name)"
        
        let toplamOdeme = secilenAktivite!.odemeler.filter("payName == %@",secilenOdeme?.payName).sum(ofProperty: "price") ?? 0
        labelToplamOdeme.text = "Yapılan ödeme: \(toplamOdeme)"
        
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    


}
