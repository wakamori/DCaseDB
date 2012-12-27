import("konoha.const");
import("konoha.global");
import("konoha.json");
import("openssl");
import("cstyle");
import("konoha.class");
import("js4.array");
import("konoha.new");
import("konoha.date");

const NODE = 0;
const GOAL = 1;
const STRATEGY = 2;
const CONTEXT = 3;
const EVIDENCE = 4;
const ARGUMENT = 5;

class DBNode {
	String  name;
	String  description;
	boolean is_evidence;
	boolean is_consensus;

	DBNode(Json content) {
		if(content.hasKey("name")) {
			this.name = content.getString("name");
		}
		if(content.hasKey("description")) {
			this.name = content.getString("description");
		}
		if(content.hasKey("is_evidence")) {
			this.name = content.getString("is_evidence");
		}
	}

	Json toJson() {
		Json json = new Json();
		json.setString("name",this.name);
		json.setString("description",this.description);
		json.setBoolean("is_evidence",this.is_evidence);
		return json;
	}
}

class Link {
	String parent;
	String child;
	Link(String parent, String child) {
		this.parent = parent;
		this.child  = child;
	}

	Json toJson() {
		Json json = new Json();
		json.setString("parent",this.parent);
		json.setString("child",this.child);
		return json;
	}
}

class Context extends DBNode {
	Json condition;
	Context() {
	}
	String searchValue(String key) {
		if(this.condition.hasKey(key)) {
			return this.condition.getString(key);
		}
		return NULL;
	}
}

class Goal extends DBNode {
	Context context;
	Goal() {

	}
}

class Strategy extends DBNode {
	Context context;
	Strategy() {
	}
}

class Evidence extends DBNode {
	Evidence() {

	}
}

class Commit {
	String method;
	Json argument;
	String revision;
	String time;

	Commit(String method, Json argument, String revision) {
		this.method   = method;
		this.argument = argument;
		this.revision = revision;
		this.time     = new Date().toString();
	}

	Json toJson() {
		Json json = new Json();
		json.setString("method",this.method);
		json.set("argument",this.argument); //FIXME
		json.setString("revision",this.revision);
		json.setString("time",this.time);

		return json;
	}
}

class CommitLog {
	Commit[] commits;
	String head;
	MD5 md5;

	CommitLog() {
		this.commits = new Commit[0];
		this.md5 = new MD5();
		md5.update(new Date().toString());
	}

	String addCommit(String method, Json argument) {
		Commit commit = new Commit(method, argument, this.md5.final());
		this.commits.add(commit);
		this.head = commit.revision;
		return commit.revision;
	}

	Json toJson() {
		Json json = Json.parse("[]");
		for(int i = 0;i < this.commits.getSize(); i++) {
			json.add(this.commits[i].toJson());
		}
		return json;
	}
}

class Tree {
	CommitLog commit_log;
	DBNode     root;
	DBNode[]   nodes;
	Link[]   links;

	Tree(Goal root) {
		this.root = root;
		this.commit_log = new CommitLog();
	}

	@Private Json jsonTree() {
		Json json = new Json();
		json.setString("root",this.root.name);
		json.set("nodes",this.DBNodesToJson());
		json.set("links",this.LinksToJson());
		return json;
	}

	@Private Json jsonCommitLog() {
		return this.commit_log.toJson();
	}

	@Private String CommitHead() {
		return this.commit_log.head;
	}

	void Commit(String method, Json argument) {
		this.commit_log.addCommit(method,argument);
	}

	@Private Json DBNodesToJson() {
		Json json = Json.parse("[]");
		for(int i = 0; i < this.nodes.getSize();i++) {
			json.add(this.nodes[i].toJson());
		}
		return json;
	}

	@Private Json LinksToJson() {
		Json json = Json.parse("[]");
		for(int i = 0;i < this.links.getSize();i++) {
			json.add(this.links[i].toJson());
		}
		return json;
	}

	Json toJson() {
		Json json = this.jsonTree();
		json.set("CommitLog",this.jsonCommitLog());
		json.setString("HEAD", this.CommitHead());
		return json;
	}

	@Private DBNode searchTree(String search) {
		for(int i = 0; i < this.nodes.getSize(); i++) {
			if(this.nodes[i].name == search) {
				return this.nodes[i];
			}
		}
		return NULL;
	}
}

class DCaseRepository {
	Tree tree;

	void CreateTree() {
		Goal g = new Goal();
		g.name = "Root";
		this.tree = new Tree(g);
	}

	void Connect() {
		this.CreateTree(); //FIXME
	}

	//TODO Search Argument
	Tree SearchTree() {
		return this.tree;
	}

	//TODO many tree & return DBNode[]
	DBNode SearchDBNode(DBNode root, String searchText) {
		return this.tree.searchTree(searchText);
	}

	DBNode CreateDBNode(int DBNodeType, Json content) {
		if(DBNodeType == GOAL) {
			content.setString("DBNodeType","GOAL");
			this.tree.Commit("Create",content);

			Goal node = new Goal(content);
			this.tree.nodes.add(node);
			return node;
		} else if (DBNodeType == STRATEGY) {
			content.setString("DBNodeType","STRATEGY");
			this.tree.Commit("Create",content);

			Strategy node = new Strategy(content);
			this.tree.nodes.add(node);
			return node;
		} else if (DBNodeType == CONTEXT) {
			content.setString("DBNodeType","CONTEXT");
			this.tree.Commit("Create",content);

			Context node = new Context(content);
			this.tree.nodes.add(node);
			return node;
		} else if (DBNodeType == EVIDENCE) {
			content.setString("DBNodeType","EVIDENCE");
			this.tree.Commit("Create",content);

			Evidence node = new Evidence(content);
			this.tree.nodes.add(node);
			return node;
		}
		return new DBNode();
	}

	void InsertDBNode(String parent, String child) {
		Link l = new Link(parent, child);
		this.tree.links.add(l);
		this.tree.Commit("Insert",l.toJson());
	}

	//TODO
	void UpdateDBNode(DBNode node, Json contents) {
		this.tree.Commit("Update",contents.toJson());
		node.update(contents);
	}

	//TODO
	void DeleteDBNode(DBNode parent, DBNode child) {
		//this.tree.Commit("Delete",);
		//this.tree.deleteLink(parent,child);
	}

}
