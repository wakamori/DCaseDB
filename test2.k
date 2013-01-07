load("db.k");
import("konoha.object");

Strategy makeStrategy(DCaseDB repo, String treeName, String name,String description) {
	Json json = new Json();
	json.setString("name",name);
	json.setString("description",description);
	json.setString("DBNodeType","Strategy");
	return repo.CreateDBNode(treeName,json) as Strategy;
}

Goal makeGoal(DCaseDB repo, String treeName, String name,String description) {
	Json json = new Json();
	json.setString("name",name);
	json.setString("description",description);
	json.setString("DBNodeType","Goal");
	return repo.CreateDBNode(treeName, json) as Goal;
}

Evidence makeEvidence(DCaseDB repo, String treeName, String name,String description) {
	Json json = new Json();
	json.setString("name",name);
	json.setString("description",description);
	json.setString("DBNodeType","Evidence");
	return repo.CreateDBNode(treeName, json) as Evidence;
}

void main() {
	String TreeName = "tree";
	String TreeName2 = "mosh";
	DCaseDB repo = new DCaseDB();
	repo.CreateArgument(TreeName);
	repo.CreateArgument(TreeName2);

	Strategy s1 = makeStrategy(repo, TreeName, "S-1", "S-1 test");
	repo.InsertLink(TreeName, repo.SearchArgument(TreeName).root.name, s1.name);

	Goal g2_1 = makeGoal(repo, TreeName, "G2-1", "G2-1 test");
	repo.InsertLink(TreeName, s1.name , g2_1.name);

	Goal g2_2 = makeGoal(repo, TreeName, "G2-2", "G2-2 test");
	repo.InsertLink(TreeName, s1.name , g2_2.name);

	Evidence e1 = makeEvidence(repo, TreeName, "E1", "E1 test");
	repo.InsertLink(TreeName, g2_1.name , e1.name);

	Strategy s = repo.SearchDBNode(TreeName,"S-1") as Strategy;
	Json s_args = new Json();
	s_args.setString("description","updated.");
	repo.UpdateDBNode(TreeName, s,s_args);

	System.p(repo.searchArgument(TreeName2).toJson());
	System.p(repo.searchArgument(TreeName).toJson());
}

main();
