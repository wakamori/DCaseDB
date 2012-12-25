load("db.k");

void main() {
	DCaseRepository repo = new DCaseRepository();
	repo.init();
	repo.getTree().dumpTree();

	Node n = repo.create(STRATEGY,new Json());
	n.name = "strategy";
	repo.Insert(repo.tree.root.name, n.name);
	repo.getTree().dumpTree();
	repo.getTree().dumpTree();

	Node subgoal = repo.create(GOAL,new Json());
	subgoal.name = "subgoal";
	repo.Insert(n.name , subgoal.name);
	repo.getTree().dumpTree();
}

main();
