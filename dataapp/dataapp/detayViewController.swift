//
//  detayViewController.swift
//  dataapp
//
//  Created by Ferhat Toson on 25.06.2022.
//

import UIKit
import CoreData

class detayViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
     var secilenurun=""
    var secilenid:UUID?
    
    @IBOutlet weak var bedentf: UITextField!
    @IBOutlet weak var isimtf: UITextField!
    @IBOutlet weak var fiyattf: UITextField!
    @IBOutlet weak var imageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if secilenurun != "" {
            if  let idstr = secilenid?.uuidString{
                let appdel=UIApplication.shared.delegate as! AppDelegate
                let con=appdel.persistentContainer.viewContext
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Alisveris")
                fetch.predicate=NSPredicate(format: "id=%@", idstr)
                do{
                    let sonuclar = try con.fetch(fetch)
                    for sonuc in sonuclar as! [NSManagedObject] {
                        if let isim = (sonuc.value(forKey: "isim") as? String){
                            isimtf.text=isim
                        }
                        if let fiyat = (sonuc.value(forKey: "fiyat") as? Int){
                            fiyattf.text=String(fiyat)
                        }
                        if let beden = (sonuc.value(forKey: "beden") as? String){
                            bedentf.text=beden
                        }
                        if let gordata = sonuc.value(forKey: "gorsel") as? Data{
                            let image = UIImage(data: gordata)
                            imageview.image=image
                        }
                    }
                }catch{
                    
                }
                
            }
        }
        else{
            isimtf.text=""
            bedentf.text=""
            fiyattf.text=""
        }
        imageview.isUserInteractionEnabled=true
        let imagegusturecognizer=UITapGestureRecognizer(target: self, action: #selector(gorselsec))
        imageview.addGestureRecognizer(imagegusturecognizer)
        // Do any additional setup after loading the view.
    }
    
    @objc func gorselsec(){
       let picker=UIImagePickerController()
        picker.delegate=self
        picker.sourceType = .photoLibrary
        picker.allowsEditing=true
        present(picker, animated: true, completion: nil)
    
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageview.image=info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func kaydettikla(_ sender: Any) {
        let appdelegate=UIApplication.shared.delegate as! AppDelegate
        let context=appdelegate.persistentContainer.viewContext
        let alisveris=NSEntityDescription.insertNewObject(forEntityName: "Alisveris", into: context)
        alisveris.setValue(isimtf.text!, forKey: "isim")
        alisveris.setValue(bedentf.text!, forKey: "beden")
        alisveris.setValue(UUID(), forKey: "id")

        if let fiyat=Int(fiyattf.text!){
            alisveris.setValue(fiyat, forKey: "fiyat")

        }
        let data=imageview.image?.jpegData(compressionQuality: 0.5)
        alisveris.setValue(data, forKey: "gorsel")
        do{
            try context.save()
            print("başarılı")
        }catch{
         print("başarısız")
        }

        
    
    
    }
    
}
