/* create share records for community user from vendor contact record */
public class CreateShareCommuityUser implements Queueable {
    
    private List<User> urs;
    
    public CreateShareCommuityUser(List<User> records) {
       urs= records;
    }
    public void execute(QueueableContext context) {
        Set<Id> Uids = new Set<Id>();
        for(User u: urs) 
            Uids.add(u.id);
        UserTriggerHandler.shareVendorRecord(Uids); 
       // createVedorCommunityUser(cons);
    }
  }