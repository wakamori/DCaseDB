import("konoha.const");
import("konoha.global");
import("konoha.json");
import("openssl");
import("cstyle");
import("konoha.class");
import("js4.array");
import("konoha.date");
import("konoha.map");

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
	//boolean is_consensus;

	DBNode(Json content) {
		this.updateContent(content);
	}

	Json toJson() {
		Json json = new Json();
		json.setString("name",this.name);
		json.setString("description",this.description);
		json.setBoolean("is_evidence",this.is_evidence);
		return json;
	}

	@Private void updateContent(Json content) {
		if(content.hasKey("name")) {
			this.name = content.getString("name");
		}
		if(content.hasKey("description")) {
			this.description = content.getString("description");
		}
		if(content.hasKey("is_evidence")) {
			this.is_evidence = content.getBoolean("is_evidence");
		}
	}

	Json update(Json content) {
		Json json = new Json();
		json.set("before",this.toJson());
		this.updateContent(content);
		json.set("after", this.toJson());
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

//TODO
class Goal extends DBNode {
	Context context;
	Goal() {}
}

class Strategy extends DBNode {
	Context context;
	Strategy() {}
}

class Evidence extends DBNode {
	Evidence() {}
}

class Commit {
	String method;
	Json argument;
	String revision;
	int time;

	Commit(String method, Json argument, String revision) {
		this.method   = method;
		this.argument = argument;
		this.revision = revision;
		this.time     = new Date().getTime();
	}

	Json toJson() {
		Json json = new Json();
		json.setString("method",this.method);
		json.set("argument",this.argument); //FIXME
		json.setString("revision",this.revision);
		json.setInt("time",this.time);

		return json;
	}
}

class CommitLog {
	Commit[] commits;
	String head;
	MD5 md5;

	CommitLog() {
		this.commits = [];
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
	Map[Tree] tree;

	void CreateTree(String name) {
		Goal g = new Goal();
		g.name = "Root";
		this.tree.set(name,new Tree(g));
	}

	void Connect() {
		//FIXME
	}

	//TODO Search Argument
	Tree SearchTree(String name) {
		return this.tree.get(name);
	}

	//TODO many tree & return DBNode[]
	DBNode SearchDBNode(String root, String searchText) {
		return this.tree.get(root).searchTree(searchText);
	}

	DBNode CreateDBNode(String name, int DBNodeType, Json content) {
		if(DBNodeType == GOAL) {
			content.setString("DBNodeType","GOAL");
			this.tree.get(name).Commit("Create",content);

			Goal node = new Goal(content);
			this.tree.get(name).nodes.add(node);
			return node;
		} else if (DBNodeType == STRATEGY) {
			content.setString("DBNodeType","STRATEGY");
			this.tree.get(name).Commit("Create",content);

			Strategy node = new Strategy(content);
			this.tree.get(name).nodes.add(node);
			return node;
		} else if (DBNodeType == CONTEXT) {
			content.setString("DBNodeType","CONTEXT");
			this.tree.get(name).Commit("Create",content);

			Context node = new Context(content);
			this.tree.get(name).nodes.add(node);
			return node;
		} else if (DBNodeType == EVIDENCE) {
			content.setString("DBNodeType","EVIDENCE");
			this.tree.get(name).Commit("Create",content);

			Evidence node = new Evidence(content);
			this.tree.get(name).nodes.add(node);
			return node;
		}
		return new DBNode();
	}

	void InsertDBNode(String name, String parent, String child) {
		Link l = new Link(parent, child);
		this.tree.get(name).links.add(l);
		this.tree.get(name).Commit("Insert",l.toJson());
	}

	void UpdateDBNode(String name, DBNode node, Json contents) {
		Json log = node.update(contents);
		this.tree.get(name).Commit("Update",log);
	}

	//TODO
	void DeleteDBNode(DBNode parent, DBNode child) {
		//this.tree.Commit("Delete",);
		//this.tree.deleteLink(parent,child);
	}

}
