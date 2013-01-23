load("../dcasecloud_glue.k");


void main() {

	API repo = new API("dcasedb","dcasedb");
	int[] Ids = repo.GetArgumentIds();
	Argument argument = repo.GetArgument(Ids[1]);
	System.p(argument.toJson());

	System.p(repo.GetContext(argument.GetDBNode(7)));
}

main();
