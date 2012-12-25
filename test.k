load("db.k");
import("konoha.object");

void main() {
	DCaseRepository repo = new DCaseRepository();
	repo.Initialize();
	System.p(repo.getTree().jsonTree());

	Json n_args = new Json();
	n_args.setString("name","strategy");
	Strategy n = repo.Create(STRATEGY,n_args) as Strategy;
	repo.Insert(repo.tree.root.name, n.name);
	System.p(repo.getTree().jsonTree());

	Json subgoal_args = new Json();
	subgoal_args.setString("name","subgoal");
	Goal subgoal = repo.create(GOAL,subgoal_args) as Goal;
	repo.Insert(n.name , subgoal.name);
	System.p(repo.getTree().jsonTree());

	Strategy s = repo.Select(NULL,"strategy") as Strategy;

	System.p(repo.getTree().jsonCommitLog());
}

main();
