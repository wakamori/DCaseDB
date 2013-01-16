import("cstyle.file");
load("../dcasedb_glue.k");


void main() {
	String TreeName = "BasicSyntax";

	DCaseDB repo = new DCaseDB();
	repo.Connect("dcasedb","dcasedb");

	Json json = new Json();
	json.setString("OS","Ubuntu 12.04");
	json.setString("Architecture","x86_64");
	json.setString("C Compiler","GCC 4.6.3");
	repo.AddContext(TreeName,"BasicSyntaxContext",json);
	stdout.println(repo.SearchArgument(TreeName).toJson());
}

main();
