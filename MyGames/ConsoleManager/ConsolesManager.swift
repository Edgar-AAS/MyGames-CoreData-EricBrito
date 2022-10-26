import CoreData

class ConsolesManager {
    static let shared = ConsolesManager()
    
    private init() {}
    
    var consoles: [Console] = []

    func loadConsoles(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sorDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sorDescriptor] 
        
        do {
            consoles = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
    func deleteConsole(index: Int, context: NSManagedObjectContext) {
        let console = consoles[index]
        context.delete(console)

        do {
            try context.save()
            consoles.remove(at: index)
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
