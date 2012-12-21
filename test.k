load("MiniDcaseDB.k");

void main() {
	DCaseRepository repo = new DCaseRepository();
	repo.init();
	repo.getTree().dumpTree();
}

main();
