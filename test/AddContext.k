import("cstyle.file");
load("../dcasedb_glue.k");


void main() {
	String TreeName = "BasicSyntax";

	DCaseDB repo = new DCaseDB();
	repo.Connect("dcasedb","dcasedb");

	Json json = new Json();
	json.setString("CPU","Core i7");
	repo.AddContext(TreeName,"BasicSyntaxContext",json);
	stdout.println(repo.SearchArgument(TreeName).toJson());
}

main();
