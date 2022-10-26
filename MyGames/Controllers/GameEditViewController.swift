import UIKit

class GameEditViewController: UIViewController, UIPickerViewDelegate {
    @IBOutlet var tfTitle: UITextField!
    @IBOutlet var tfConsole: UITextField!
    @IBOutlet var dpReleaseDate: UIDatePicker!
    @IBOutlet var btAddEdit: UIButton!
    @IBOutlet var btCover: UIButton!
    @IBOutlet var ivCover: UIImageView!
    
    //linha da tabela
    var game: Game!
    var consolesManager = ConsolesManager.shared

    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if game != nil {
            title = "Editar jogo"
            btAddEdit.setTitle("ALTERAR", for: .normal)
            
            tfTitle.text = game.title
            
            if let console = game.console, let index = consolesManager.consoles.firstIndex(of: console) {
                tfConsole.text = console.name
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            
            ivCover.image = game.cover as? UIImage
            
            if let releaseDate = game.releaseDate {
                dpReleaseDate.date = releaseDate
            }
            
            if game.cover != nil {
                btCover.setTitle(nil, for: .normal)
            }
        }
        
        prepareConsoleTextField()
    }
    
    
    func prepareConsoleTextField() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolBar.tintColor = UIColor(named: "main")
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [btCancel, btFlexibleSpace, btDone]
        
        tfConsole.inputAccessoryView = toolBar
        tfConsole.inputView = pickerView
    }

    @objc func cancel() {
        tfConsole.resignFirstResponder()
    }
    
    @objc func done() {
        let index = pickerView.selectedRow(inComponent: 0)
        tfConsole.text = consolesManager.consoles[index].name
        cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        consolesManager.loadConsoles(with: context)
    }
    
    @IBAction func addEditCover(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde voce quer ver o poster?", preferredStyle: .actionSheet)
            
        //        se existe camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            }
            
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        
        alert.addAction(libraryAction)
        
        let photoScan = UIAlertAction(title: "Album de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        
        alert.addAction(photoScan)
        
        let cancel = UIAlertAction(title: "Cancelar ", style: .cancel) { (action: UIAlertAction) in }
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addEditGame(_ sender: UIButton) {
        if game == nil {
            game = Game(context: context)
        }
        
        game.title = tfTitle.text
        game.releaseDate = dpReleaseDate.date
        game.cover = ivCover.image
        
        if !tfConsole.text!.isEmpty {
            let index = pickerView.selectedRow(inComponent: 0)
            let console = consolesManager.consoles[index]
            game.console = console
        }
        
        saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension GameEditViewController: UIDocumentPickerDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consolesManager.consoles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = consolesManager.consoles[row]
        return console.name
    }
}

extension GameEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        ivCover.image = image
        btCover.setTitle(nil, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
