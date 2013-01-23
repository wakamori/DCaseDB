load("../dcasecloud_glue.k");


void main() {

	API repo = new API("dcasedb","dcasedb");
	int[] Ids = repo.GetArgumentIds();
	Argument argument = repo.GetArgument(Ids[1]);
	System.p(argument.toJson());

	Json json = new Json();
	json.setString("OS","Ubuntu 12.04");
	json.setString("Architecture","x86_64");
	json.setString("C Compiler","GCC 4.6.3");
	repo.AddContext(Ids[1],argument.GetRoot().nodeId,json);
	System.p(argument.toJson());
}

main();
