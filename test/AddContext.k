load("../dcasecloud_glue.k");


void main() {

	API repo = new API("dcasedb","dcasedb");
	Json Ids = repo.GetArgumentIds();
	System.p(Ids);
	DCaseArgument argument = repo.GetArgument(9);
	System.p(argument.toJson());

	Json json = new Json();
	json.setString("OS","Ubuntu 12.04");
	json.setString("Architecture","x86_64");
	json.setString("C Compiler","GCC 4.6.3");
	json.setString("C++ Compiler","G++ 4.6.3");
	repo.AddContext(9,argument.GetRoot().node_id,json);
	System.p(argument.toJson());
}

main();
