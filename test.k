load("db.k");
import("konoha.object");
//import("konoha.file");

void main() {
	String name = "tree";
	DCaseRepository repo = new DCaseRepository();
	repo.CreateTree(name);
	System.p(repo.SearchTree(name).toJson());

	Json n_args = new Json();
	n_args.setString("name","strategy");
	Strategy n = repo.CreateDBNode(name,STRATEGY,n_args) as Strategy;
	repo.InsertLink(name, repo.SearchTree(name).root.name, n.name);
	System.p(repo.SearchTree(name).toJson());

	Json subgoal_args = new Json();
	subgoal_args.setString("name","subgoal");
	Goal subgoal = repo.CreateDBNode(name, GOAL,subgoal_args) as Goal;
	repo.InsertLink(name, n.name , subgoal.name);
	System.p(repo.SearchTree(name).toJson());

	Strategy s = repo.SearchDBNode(name,"strategy") as Strategy;
	Json s_args = new Json();
	s_args.setString("description","updated.");
	repo.UpdateDBNode(name, s,s_args);

	System.p(repo.searchTree(name).toJson());
}

main();
