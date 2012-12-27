load("db.k");
import("konoha.object");
import("konoha.file");

void main() {
	DCaseRepository repo = new DCaseRepository();
	repo.Connect();
	stdout.println(repo.SearchTree().toJson());

	Json n_args = new Json();
	n_args.setString("name","strategy");
	Strategy n = repo.CreateDBNode(STRATEGY,n_args) as Strategy;
	repo.InsertDBNode(repo.SearchTree().root.name, n.name);
	stdout.println(repo.SearchTree().toJson());

	Json subgoal_args = new Json();
	subgoal_args.setString("name","subgoal");
	Goal subgoal = repo.CreateDBNode(GOAL,subgoal_args) as Goal;
	repo.InsertDBNode(n.name , subgoal.name);
	stdout.println(repo.getTree().toJson());

	Strategy s = repo.SearchDBNode(NULL,"strategy") as Strategy;

	stdout.println(repo.getTree().toJson());
}

main();
