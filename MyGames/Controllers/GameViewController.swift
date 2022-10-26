import UIKit
import CoreData

class GameViewController: UIViewController {
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbConsole: UILabel!
    @IBOutlet var lbReleaseDate: UILabel!
    @IBOutlet var ivCover: UIImageView!
    
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGameLayout()
    }
    
    func setupGameLayout() {
        lbTitle.text = game.title
        lbConsole.text = game.console?.name
    
        
        if let releaseDate = game.releaseDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "pt-BR")
            //devolve string formatada da data
            lbReleaseDate.text = "Lançamento : " + formatter.string(from: releaseDate)
        }
        
        if let image = game.cover as? UIImage {
            ivCover.image = image
        } else {
            ivCover.image = UIImage(named: "noCoverFull")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameEditVC = segue.destination as? GameEditViewController else { return }
        gameEditVC.game = game
    }
}
