load("db.k");

void main() {
	DCaseRepository repo = new DCaseRepository();
	repo.Initialize();
	System.p(repo.getTree().jsonTree());

	Json n_args = new Json();
	n_args.setString("name","strategy");
	Node n = repo.Create(STRATEGY,n_args);
	repo.Insert(repo.tree.root.name, n.name);
	System.p(repo.getTree().jsonTree());

	Json subgoal_args = new Json();
	subgoal_args.setString("name","subgoal");
	Node subgoal = repo.create(GOAL,subgoal_args);
	repo.Insert(n.name , subgoal.name);
	System.p(repo.getTree().jsonTree());

	Node s = repo.Select(NULL,"strategy");

	System.p(repo.getTree().jsonCommitLog());
}

main();
