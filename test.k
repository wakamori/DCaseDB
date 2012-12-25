load("db.k");

void main() {
	DCaseRepository repo = new DCaseRepository();
	repo.Initialize();
	repo.getTree().dumpTree();

	Json n_args = new Json();
	n_args.setString("name","strategy");
	Node n = repo.Create(STRATEGY,n_args);
	repo.Insert(repo.tree.root.name, n.name);
	repo.getTree().dumpTree();

	Json subgoal_args = new Json();
	subgoal_args.setString("name","subgoal");
	Node subgoal = repo.create(GOAL,subgoal_args);
	repo.Insert(n.name , subgoal.name);
	repo.getTree().dumpTree();

	Node s = repo.Select(NULL,"strategy");

	repo.getTree().dumpCommitLog();
}

main();
