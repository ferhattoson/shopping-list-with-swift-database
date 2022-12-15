//
//  ViewController.swift
//  dataapp
//
//  Created by Ferhat Toson on 25.06.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var isimler=[String]()
    var idler=[UUID]()
    var secilenurun=""
    var secilenid:UUID?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=UITableViewCell()
        cell.textLabel?.text=isimler[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isimler.count
    }
    func verial(){
        let appdelegat=UIApplication.shared.delegate as! AppDelegate
        let context=appdelegat.persistentContainer.viewContext
        let fetchrequest=NSFetchRequest<NSFetchRequestResult>(entityName: "Alisveris")
        fetchrequest.returnsObjectsAsFaults=false
        do{
            let sonuclar = try context.fetch(fetchrequest)
            for sonuc in sonuclar as! [NSManagedObject]{
                
                if let isim=sonuc.value(forKey: "isim") as? String{
                    isimler.append(isim) }
                if let id=sonuc.value(forKey: "id") as? UUID{
                    idler.append(id)
                }
                tableView.reloadData()

            }
            print("veri alındı")

            tableView.reloadData()
        }catch {
         print("hatalı veri")
        }
        
        
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        navigationController?.navigationBar.topItem?.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem:  UIBarButtonItem.SystemItem.add, target: self, action: #selector(ekletikla))
        // Do any additional setup after loading the view.
        verial()
    }
    @objc func  ekletikla(){
        secilenurun=""
        performSegue(withIdentifier: "todetavc", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="todetavc"{
            let des=segue.destination as! detayViewController
            des.secilenurun=secilenurun
            des.secilenid=secilenid
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilenurun=isimler[indexPath.row]
        secilenid=idler[indexPath.row]
     performSegue(withIdentifier: "todetavc", sender: nil)    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let idstr=idler[indexPath.row].uuidString
            let appdel=UIApplication.shared.delegate as! AppDelegate
            let con=appdel.persistentContainer.viewContext
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Alisveris")
            fetch.predicate=NSPredicate(format: "id=%@", idstr)
            do{
                let sonuclar = try con.fetch(fetch)
                for sonuc in sonuclar as! [NSManagedObject]{
                    if let id = sonuc.value(forKey: "id") as? UUID{
                        if id==idler[indexPath.row]{
                            con.delete(sonuc)
                            isimler.remove(at: indexPath.row)
                            idler.remove(at: indexPath.row)
                            self.tableView.reloadData()
                            do{          try con.save()
                            }catch{
                                
                            } ;break
                        }
                    }
                }
            }catch {
                
            }
        }
    }
}

