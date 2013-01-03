load("db.k");
import("konoha.object");
//import("konoha.file");

void main() {
	String name = "tree";
	DCaseRepository repo = new DCaseRepository();
	repo.CreateArgument(name);
	System.p(repo.SearchArgument(name).toJson());

	Json n_args = new Json();
	n_args.setString("name","strategy");
	n_args.setString("DBNodeType","Strategy");
	Strategy n = repo.CreateDBNode(name,n_args) as Strategy;
	repo.InsertLink(name, repo.SearchArgument(name).root.name, n.name);
	System.p(repo.SearchArgument(name).toJson());

	Json subgoal_args = new Json();
	subgoal_args.setString("name","subgoal");
	subgoal_args.setString("DBNodeType","Goal");
	Goal subgoal = repo.CreateDBNode(name,subgoal_args) as Goal;
	repo.InsertLink(name, n.name , subgoal.name);
	System.p(repo.SearchArgument(name).toJson());

	Strategy s = repo.SearchDBNode(name,"strategy") as Strategy;
	Json s_args = new Json();
	s_args.setString("description","updated.");
	repo.UpdateDBNode(name, s,s_args);

	System.p(repo.searchArgument(name).toJson());
	repo.DeleteDBNode(name,"strategy");
	System.p(repo.searchArgument(name).toJson());
}

main();
