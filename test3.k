load("db.k");


void main() {
	String TreeName = "tree";

	DCaseDB repo = new DCaseDB();
	repo.Connect("dcasedb","dcasedb");

	System.p(repo.SearchArgument(TreeName).toJson());
}

main();
