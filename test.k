load("db.k");
import("konoha.object");
import("konoha.file");

void main() {
	String name = "tree";
	DCaseRepository repo = new DCaseRepository();
	repo.CreateTree(name);
	stdout.println(repo.SearchTree(name).toJson());

	Json n_args = new Json();
	n_args.setString("name","strategy");
	Strategy n = repo.CreateDBNode(name,STRATEGY,n_args) as Strategy;
	repo.InsertDBNode(name, repo.SearchTree(name).root.name, n.name);
	stdout.println(repo.SearchTree(name).toJson());

	Json subgoal_args = new Json();
	subgoal_args.setString("name","subgoal");
	Goal subgoal = repo.CreateDBNode(name, GOAL,subgoal_args) as Goal;
	repo.InsertDBNode(name, n.name , subgoal.name);
	stdout.println(repo.SearchTree(name).toJson());

	Strategy s = repo.SearchDBNode(name,"strategy") as Strategy;
	Json s_args = new Json();
	s_args.setString("description","updated.");
	repo.UpdateDBNode(name, s,s_args);

	stdout.println(repo.searchTree(name).toJson());
}

main();
