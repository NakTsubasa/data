//
//  EditarContactoViewController.swift
//  Contactos
//
//  Created by Catalina on 09/11/20.
//

import UIKit
import CoreData

class EditarContactoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var contactos = [Contacto]()
    var contacto : Contacto?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var recibirNombre : String?
    var recibirTelefono : String?
    var recibirDireccion : String?
    var recibirIndice : Int?
    
    
    @IBOutlet weak var imageViewContacto: UIImageView!
    
    @IBOutlet weak var nombreContactoTextField: UITextField!
    
    @IBOutlet weak var telefonoContactoTextField: UITextField!
    
    @IBOutlet weak var direccionContactoTextField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nombreContactoTextField.text = recibirNombre
        telefonoContactoTextField.text = recibirTelefono
        direccionContactoTextField.text = recibirDireccion
    
        cargarData()
        if(contactos[recibirIndice!].image != nil){
            imageViewContacto.image = UIImage(data: contactos[recibirIndice!].image!)
            
        }else{
            print("No hay imagen")
        }
    
        print(contactos[recibirIndice!])
        
    }
    
    
    
    @IBAction func AceptarButton(_ sender: UIButton) {
        
        if(nombreContactoTextField.text == "" || telefonoContactoTextField.text == "" || direccionContactoTextField.text == ""){
            
            let alertaEdit = UIAlertController(title: "Error", message: "Hay Campos Vacios", preferredStyle: .alert)
            let actionEdit = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertaEdit.addAction(actionEdit)
            self.present(alertaEdit, animated: true, completion: nil)
            
        }else{
        
        do{
            guard let i = recibirIndice else { return }
            contactos[i].setValue(nombreContactoTextField.text, forKey: "nombre")
            contactos[i].setValue(Int64(telefonoContactoTextField.text!), forKey: "telefono")
            contactos[i].setValue(direccionContactoTextField.text, forKey: "direccion")
            contactos[i].setValue(imageViewContacto.image?.pngData(), forKey: "image")
            try self.context.save()
            print("Se edito Bien")
        } catch{
            print(error.localizedDescription)
        }
        
        nombreContactoTextField.text = ""
        telefonoContactoTextField.text = ""
        direccionContactoTextField.text = ""
        navigationController?.popViewController(animated: true)
        
    }
}
    
    
    @IBAction func cancelarButton(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    func cargarData() {
        let fetchRequest : NSFetchRequest<Contacto> = Contacto.fetchRequest()
        do{
            contactos =  try context.fetch(fetchRequest)
            
        } catch let error as NSError{
            print("Error al cargar\(error)")
        }
    }
    
    @IBAction func agregarFoto(_ sender: UIBarButtonItem) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
        imageViewContacto.image = userPickedImage
        picker.dismiss(animated: true)
    }
    
   
    //OcultarTeclado
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
