load("db.k");
import("konoha.object");
import("konoha.file");

void main() {
	DCaseRepository repo = new DCaseRepository();
	repo.Initialize();
	stdout.println(repo.getTree().toJson());

	Json n_args = new Json();
	n_args.setString("name","strategy");
	Strategy n = repo.Create(STRATEGY,n_args) as Strategy;
	repo.Insert(repo.tree.root.name, n.name);
	stdout.println(repo.getTree().toJson());

	Json subgoal_args = new Json();
	subgoal_args.setString("name","subgoal");
	Goal subgoal = repo.create(GOAL,subgoal_args) as Goal;
	repo.Insert(n.name , subgoal.name);
	stdout.println(repo.getTree().toJson());

	Strategy s = repo.Select(NULL,"strategy") as Strategy;

	stdout.println(repo.getTree().toJson());
}

main();
