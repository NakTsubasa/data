//
//  ViewController.swift
//  Contactos
//
//  Created by Catalina on 03/11/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    //Variables Contacto
    var nombreContacto : String?
    var telefonoContacto : String?
    var direccionContacto : String?
    var indexContacto : Int?
    
    //Arreglo de Objetos  tipo MiContacto
    var contactos  = [Contacto]()
    
    //declaracion de contezto para BD
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var TablaContactos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TablaContactos.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier:"celda")
        
        TablaContactos.delegate = self
        TablaContactos.dataSource = self
        cargarData()
        TablaContactos.reloadData()
        
        
    }
    //FUNCION PARA QUE SE RECARGUE CUANDO SE REGRESE A LA PANTALLA ANTERIOR
    override func viewWillAppear(_ animated: Bool) {
        TablaContactos.reloadData()
    }

    @IBAction func agregarContacto(_ sender: UIBarButtonItem) {
        let alerta = UIAlertController(title: "Agregar Contacto", message: "Agrega un Contacto", preferredStyle: .alert)
        alerta.addTextField { (nombreAlerta) in
            nombreAlerta.placeholder = "Nombre"
        }
        alerta.addTextField { (telefonoAlerta) in
            telefonoAlerta.placeholder = "Telefono"
        }
        alerta.addTextField { (direccionAlerta) in
            direccionAlerta.placeholder = "Direccion"
        }
        
        let actionAceptar = UIAlertAction(title: "Aceptar", style: .default) { (_) in
            //cracion de atributos del
            guard let nombreAlerta = alerta.textFields?.first?.text else { return }
            guard let telefonoAlerta = alerta.textFields?[1].text else { return }
            guard let direccionAlerta = alerta.textFields?.last?.text else { return }
            //Crear un contacto Nuevo
            
            //conexion de Base de Datos para CREATE
            let nuevoContacto  = Contacto(context: self.context)
            nuevoContacto.nombre = nombreAlerta
            nuevoContacto.telefono = Int64(telefonoAlerta) ?? 0
            nuevoContacto.direccion = direccionAlerta
            
            if(nombreAlerta == "" || direccionAlerta == ""){
                let alertaNada = UIAlertController(title: "No hay Contacto", message: "El contacto que intentas agregar NO es valido", preferredStyle: .alert)
                
                let actionNada = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertaNada.addAction(actionNada)
                self.present(alertaNada, animated: true, completion: nil)
                
            }else{
                self.contactos.append(nuevoContacto)
                self.guardarContacto()
                self.TablaContactos.reloadData()
            }
            
            
        }
        
        
        let actionCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        
        alerta.addAction(actionAceptar)
        alerta.addAction(actionCancelar)
        present(alerta, animated: true, completion: nil)
        
        
        
    }
    
    func guardarContacto(){
        do{
            try self.context.save()
            print("Si se guardo")
            
        } catch let error as NSError{
            print("Error al gurdar \(error.localizedDescription)")
        }
        
    }
    
    func cargarData() {
        let fetchRequest : NSFetchRequest<Contacto> = Contacto.fetchRequest()
        do{
            contactos =  try context.fetch(fetchRequest)
            
        } catch let error as NSError{
            print("Error al cargar\(error)")
        }
    }
    
    
    func fetchImage() -> [Contacto] {
        var fetchingImage = [Contacto]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "image")
        do {
            fetchingImage = try context.fetch(fetchRequest) as! [Contacto]
        } catch {
            print("Error while fetching the image")
        }
        return fetchingImage
    }
}



extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = TablaContactos.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! ContactoTableViewCell
        celda.nombreLabelC?.text = contactos[indexPath.row].nombre
        celda.numeroLabelC?.text = String(contactos[indexPath.row].telefono)
        
        if(contactos[indexPath.row].image != nil){
            celda.imageC.image = UIImage(data: contactos[indexPath.row].image!)
        }else{
            print("Mentiras son puras mentiras cosas que dice la gente")
        }
        return celda
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nombreContacto = contactos[indexPath.row].nombre
        telefonoContacto = String(contactos[indexPath.row].telefono)
        direccionContacto = contactos[indexPath.row].direccion
        indexContacto = indexPath.row
        
        performSegue(withIdentifier: "editarContacto", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(contactos[indexPath.row])
            contactos.remove(at: indexPath.row)
            guardarContacto()
        }
        TablaContactos.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarContacto"{
            let objetoContacto = segue.destination as! EditarContactoViewController
            objetoContacto.recibirNombre = nombreContacto
            objetoContacto.recibirTelefono = telefonoContacto
            objetoContacto.recibirDireccion = direccionContacto
            objetoContacto.recibirIndice = indexContacto
        }
    }
    
    
    
    
}

