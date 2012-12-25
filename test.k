load("db.k");

void main() {
	DCaseRepository repo = new DCaseRepository();
	repo.Initialize();
	repo.getTree().dumpTree();

	Node n = repo.Create(STRATEGY,new Json());
	n.name = "strategy";
	repo.Insert(repo.tree.root.name, n.name);
	repo.getTree().dumpTree();

	Node subgoal = repo.create(GOAL,new Json());
	subgoal.name = "subgoal";
	repo.Insert(n.name , subgoal.name);
	repo.getTree().dumpTree();

	Node s = repo.Select(NULL,"strategy");
	System.p(s);
}

main();
