load("db.k");

void main() {
	DCaseRepository repo = new DCaseRepository();
	repo.init();
	repo.getTree().dumpTree();

	Node n = repo.create(STRATEGY,new Json());
	n.name = "strategy";
	repo.Insert(repo.tree.root, n);
	repo.getTree().dumpTree();

	Node subgoal = repo.create(GOAL,new Json());
	subgoal.name = "subgoal";
	repo.Insert(n , subgoal);
	repo.getTree().dumpTree();
}

main();
