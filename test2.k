load("db.k");
import("konoha.object");

Strategy makeStrategy(DCaseRepository repo, String treeName, String name,String description) {
	Json json = new Json();
	json.setString("name",name);
	json.setString("description",description);
	return repo.CreateDBNode(treeName,STRATEGY,json) as Strategy;
}

Goal makeGoal(DCaseRepository repo, String treeName, String name,String description) {
	Json json = new Json();
	json.setString("name",name);
	json.setString("description",description);
	return repo.CreateDBNode(treeName, GOAL, json) as Goal;
}

Evidence makeEvidence(DCaseRepository repo, String treeName, String name,String description) {
	Json json = new Json();
	json.setString("name",name);
	json.setString("description",description);
	return repo.CreateDBNode(treeName, EVIDENCE,json) as Evidence;
}

void main() {
	String name = "tree";
	DCaseRepository repo = new DCaseRepository();
	repo.CreateArgument(name);

	Strategy s1 = makeStrategy(repo, name, "S-1", "S-1 test");
	repo.InsertLink(name, repo.SearchArgument(name).root.name, s1.name);

	Goal g2_1 = makeGoal(repo, name, "G2-1", "G2-1 test");
	repo.InsertLink(name, s1.name , g2_1.name);

	Goal g2_2 = makeGoal(repo, name, "G2-2", "G2-2 test");
	repo.InsertLink(name, s1.name , g2_2.name);

	Evidence e1 = makeEvidence(repo, name, "E1", "E1 test");
	repo.InsertLink(name, g2_1.name , e1.name);

	Strategy s = repo.SearchDBNode(name,"S-1") as Strategy;
	Json s_args = new Json();
	s_args.setString("description","updated.");
	repo.UpdateDBNode(name, s,s_args);

	System.p(repo.searchArgument(name).toJson());
}

main();
