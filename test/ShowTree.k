load("../dcasedb_glue.k");


void main() {
	String TreeName = "BasicSyntax";

	DCaseDB repo = new DCaseDB();
	repo.Connect("dcasedb","dcasedb");

	System.p(repo.SearchArgument(TreeName).toJson());
}

main();
