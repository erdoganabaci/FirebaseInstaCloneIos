//
//  SecondViewController.swift
//  FirebaseInstaClone
//
//  Created by Erdo on 15.01.2019.
//  Copyright © 2019 Erdo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
class uploadVC: UIViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var uuid = NSUUID().uuidString  //unique id oluşturduk her resim farklı isimle eklensin diye.
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectedImage)) //tıklanınca ne olacağı selector ile
        imageView.addGestureRecognizer(gestureRecognizer)
        
        
    }
    @objc func selectedImage(){
        //picker acılıp kullanıcının galarisinden resim seçiyoruz
        let pickerController = UIImagePickerController()
        pickerController.delegate = self //override için güç veriyoruz uploadvc ye
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //picker yani kullanıcı galariden resim seçtikten sonra ne yapacağımızı söylüyoz . bizim resmi kullanıcının seçtiğiyle değiştiriyoz
        imageView.image = info[.editedImage] as? UIImage //galarideki editli image force cast et cünkü any döndürüyor.
        self.dismiss(animated: true, completion: nil)
        //enson info.plist e neden kullanıcının galarisiyle uğrastıgımızı söylüyoz .photo library description private kısmına seçiyoz.
        
        
    }

    @IBAction func postClicked(_ sender: Any) {
        let storage = Storage.storage() //bir obje yaratttım
        let storageRef = storage.reference()
        let mediaFolder = storageRef.child("media") //media klasörü storage de oluşturdum.
        //dataya çevircem ama kullanıcı boş değer gönderirse diye if let kontrolünü yapıyoruz
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
           
            let mediaImagesRef = mediaFolder.child("\(uuid).jpg") //media klasörünün içine(child diyerek içine girdik) datanın yolunu tanımladık.pathi verdik
            mediaImagesRef.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    //hata varsa
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    //hata yoksa
                    print("başarıyla resmi ekledin")
                    let alert = UIAlertController(title: "Succes", message: "Firebase Storage Başarıyla Ekledin", preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                    //url alıcaz onuda resmin yolunu verdiğimiz mediaImagesRefden alıcaz
                    mediaImagesRef.downloadURL(completion: { (url, error) in
                        if error == nil {
                            //direk hata yoksa
                            //üstte hatayı alıyoz hata gelirse mili saniyeler içiersinde olacağından gerek yok
                            //print("url : \(url?.absoluteURL)")
                            //Database işlemler
                            let imageURL = url?.absoluteString
                            let database = Database.database()
                            let databaseReference = database.reference()
                            let uuid1 = NSUUID().uuidString
                            //post ederken key value olarak liste halinde post edicez.
                            let post = ["image" : imageURL! , "postedby" : Auth.auth().currentUser!.email! , "posttext" : self.commentText.text! , "uuid" : self.uuid ] as [String : Any] //dictioanary olarak eklemek istediklerimizi oluşturduk.key value ilişkisi ile.
                            //databaseReference.child("users").child((Auth.auth().currentUser?.uid)!).child("post").child(uuid1).setValue("erdo")
                            databaseReference.child("users").child((Auth.auth().currentUser?.uid)!).child("post").child(uuid1).setValue(post) //her kullanıcı id ile kendi postunu oluşturcak
                            //diğer tab bara geçtiği zaman eksi image view ve commenttexi sıfırlama kod ve bir sonraki tabbara geçirme kodu
                            self.imageView.image = UIImage(named: "select.png")
                            self.commentText.text = ""
                            self.tabBarController?.selectedIndex = 0 //ilk tabbar 0. indexte 1 2 3 diye gidiyor. ve segue oluşturmadım 
                            
                            
                        }
                    })
                    
                    
                }
            }
        }
        
    }
}

