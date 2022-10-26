import UIKit

class GameTableViewCell: UITableViewCell {
    @IBOutlet var ivCover: UIImageView!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbConsole: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func prepare(with game: Game) {
        lbTitle.text = game.title ?? ""
        lbConsole.text = game.console?.name ?? ""
        //fazendo o cast do cover que é do tipo transformable em UIImage
       
        if let image =  game.cover as? UIImage {
            ivCover.image = image
        } else {
            ivCover.image = UIImage(named: "noCover")
        }
    }
    
}
