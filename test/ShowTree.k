load("../dcasecloud_glue.k");


void main() {

	API repo = new API("konoha","konoha");
	Json Ids = repo.GetArgumentIds();
	DCaseArgument argument = repo.GetArgument(Ids.get(1).getString("argument_id").toint());
	System.p(argument.toJson());
}

main();
