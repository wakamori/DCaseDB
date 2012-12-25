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

@Public class Node {
	String  name;
	String  description;
	boolean is_evidence;
	boolean is_consensus;
	Node() {

	}
	Json toJson() {
		Json json = new Json();
		json.setString("NodeName",this.name);
		return json;
	}
}

@Public class Link {
	String parent;
	String child;
	Link() {
	}

	//TODO create node id.
	Json toJson() {
		Json json = new Json();
		json.setString("parent",this.parent);
		json.setString("child",this.child);

		return json;
	}
}

@Public class Context extends Node {
	Json condition;
	Context(Json Content) {
	}
	String searchValue(String key) {
		if(this.condition.hasKey(key)) {
			return this.condition.getString(key);
		}
		return NULL;
	}
}

@Public class Goal extends Node {
	Context context;
	Goal(Json Content) {

	}
}

@Public class Strategy extends Node {
	Context context;
	Strategy(Json content) {
		if(content.hasKey("name")) {
			this.name = content.getString("name");
		}
	}
}

@Public class Evidence extends Node {
	Evidence(Json Content) {

	}
}

@Public class Commit {
	String method;
	Json argument;
	String revision;

	Commit(String method, Json argument) {
		this.method   = method;
		this.argument = argument;
		MD5 m = new MD5();
		m.update(new Date().toString());
		this.revision = m.final();
	}

	Json toJson() {
		Json json = new Json();
		json.setString("method",this.method);
		json.set("argument",this.argument); //FIXME
		json.setString("revision",this.revision);

		return json;
	}
}

@Public class CommitLog {
	Commit[] commits;

	CommitLog() {
		this.commits = new Commit[0];
	}

	String addCommit(String method, Json argument) {
		Commit commit = new Commit(method, argument);
		this.commits.add(commit);
		return commit.revision;
	}

	Json toJson() {
		String str = "[]";
		Json json = Json.parse(str);
		for(int i = 0;i < this.commits.getSize(); i++) {
			json.add(this.commits[i].toJson());
		}
		return json;
	}
}

class Tree {
	CommitLog commit_log;
	Node     root;
	Node[]   nodes;
	Link[]   links;

	Tree(Goal root) {
		this.root = root;
		this.commit_log = new CommitLog();
	}

	void dumpTree() {
		Json json = this.toJson();
		System.p(json);
	}

	void dumpCommitLog() {
		System.p(this.commit_log.toJson());
	}

	void Commit(String method, Json argument) {
		this.commit_log.addCommit(method,argument);
	}

	@Private Json NodesToJson() {
		String str = "[]";
		Json json = Json.parse(str);
		for(int i = 0; i < this.nodes.getSize();i++) {
			json.add(this.nodes[i].toJson());
		}
		return json;
	}

	@Private Json LinksToJson() {
		String str = "[]";
		Json json = Json.parse(str);
		for(int i = 0;i < this.links.getSize();i++) {
			json.add(this.links[i].toJson());
		}
		return json;
	}

	Json toJson() {
		Json json = new Json();
		json.setString("root",this.root.name);
		json.set("nodes",this.NodesToJson());
		json.set("links",this.LinksToJson());
		return json;
	}

	@Private Node searchTree(String search) {
		for(int i = 0; i < this.nodes.getSize(); i++) {
			if(this.nodes[i].name == search) {
				return this.nodes[i];
			}
		}
		return NULL;
	}
}

@Public class DCaseRepository {
	Tree tree;

	DCaseRepository() {
	}

	void Initialize() {
		Goal g = new Goal();
		g.name = "Root";
		this.tree = new Tree(g);
	}

	void connectRepository() {
		this.Initialize(); //FIXME
	}

	//TODO Search Argument
	Tree getTree() {
		return this.tree;
	}

	//TODO many tree & return Node[]
	Node Select(Node root, String searchText) {
		return this.tree.searchTree(searchText);
	}

	Node Create(int NodeType, Json content) {
		if(NodeType == GOAL) {
			content.setString("NodeType","GOAL");
			this.tree.Commit("Create",content);

			Goal node = new Goal(content);
			this.tree.nodes.add(node);
			return node;
		} else if (NodeType == STRATEGY) {
			content.setString("NodeType","STRATEGY");
			this.tree.Commit("Create",content);

			Strategy node = new Strategy(content);
			this.tree.nodes.add(node);
			return node;
		} else if (NodeType == CONTEXT) {
			content.setString("NodeType","CONTEXT");
			this.tree.Commit("Create",content);

			Context node = new Context(content);
			this.tree.nodes.add(node);
			return node;
		} else if (NodeType == EVIDENCE) {
			content.setString("NodeType","EVIDENCE");
			this.tree.Commit("Create",content);

			Evidence node = new Evidence(content);
			this.tree.nodes.add(node);
			return node;
		}
		return new Node();
	}

	void Insert(String parent, String child) {
		Link l = new Link();
		l.parent = parent;
		l.child = child;
		this.tree.links.add(l);
		this.tree.Commit("Insert",l.toJson());
	}

	void Update(Node node, Json contents) {
		this.tree.Commit("Update",contents.toJson());
		node.update(contents);
	}

	//TODO
	void Delete(Node parent, Node child) {
		//this.tree.Commit("Delete",);
		//this.tree.deleteLink(parent,child);
	}

}
