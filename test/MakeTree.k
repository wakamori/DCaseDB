Load("../dcasecloud_glue.k");
Import("JavaStyle.Object");
//Import("konoha.object");

Strategy makeStrategy(API repo, String treeName, String name,String description) {
	Json json = new Json();
	json.setString("nodeId",name);
	json.setString("description",description);
	json.setString("DBNodeType","Strategy");
	return repo.CreateDBNode(treeName,json) as Strategy;
}

Goal makeGoal(API repo, String treeName, String name,String description) {
	Json json = new Json();
	json.setString("nodeId",name);
	json.setString("description",description);
	json.setString("DBNodeType","Goal");
	return repo.CreateDBNode(treeName, json) as Goal;
}

Evidence makeEvidence(API repo, String treeName, String name,String description) {
	Json json = new Json();
	json.setString("nodeId",name);
	json.setString("description",description);
	json.setString("DBNodeType","Evidence");
	return repo.CreateDBNode(treeName, json) as Evidence;
}

Context makeContext(API repo, String treeName, String name, String description) {
	Json json = new Json();
	json.setString("nodeId",name);
	json.setString("description",description);
	json.setString("DBNodeType","Context");
	return repo.CreateDBNode(treeName, json) as Context;
}

void main() {
	String TreeName = "BasicSyntax";
	API repo = new API("dcasedb","dcasedb");
	repo.CreateArgument(TreeName,"Basic Syntax");

	DBNode root = repo.GetArgument(TreeName).GetDBNode("BasicSyntax");

	Context c = makeContext(repo, TreeName, "BasicSyntaxContext", "Basic Syntax Context");
	repo.InsertLink(TreeName, root, c);

	Strategy s1 = makeStrategy(repo, TreeName, "Strategy1", "Separated by Syntax");
	repo.InsertLink(TreeName, root, s1);

	Goal g2_1 = makeGoal(repo, TreeName, "FunctionDeclaration", "Function Decralation");
	repo.InsertLink(TreeName, s1 , g2_1);

	Goal g2_2 = makeGoal(repo, TreeName, "ReturnStatement", "Return Statement");
	repo.InsertLink(TreeName, s1 , g2_2);

	System.p(repo.GetArgument(TreeName).toJson());
}

main();
