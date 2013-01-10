import("cstyle.file");
load("dcasedb.k");


void main() {
	String TreeName = "BasicSyntax";

	DCaseDB repo = new DCaseDB();
	repo.Connect("dcasedb","dcasedb");

	Json json = new Json();
	json.setString("OS","Ubuntu 12.04 64bit");
	repo.AddContext(TreeName,"BasicSyntaxContext",json);
	stdout.println(repo.SearchArgument(TreeName).toJson());
}

main();
