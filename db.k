import("konoha.const");
import("konoha.global");
import("konoha.json");
import("openssl");
import("cstyle");
import("konoha.class");
import("konoha.array");
import("konoha.new");

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
	Node parent;
	Node child;
	Link() {
	}

	//TODO create node id.
	Json toJson() {
		Json json = new Json();
		json.setString("parent",this.parent.name);
		json.setString("child",this.child.name);

		return json;
	}
}

@Public class Context extends Node {
	Json condition;
	Context() {
	}
}

@Public class Goal extends Node {
	Context context;
	Goal() {

	}
}

@Public class Strategy extends Node {
	Context context;
	Strategy() {

	}
}

@Public class Evidence extends Node {
	Context context;
	Evidence() {

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
}

@Public class Tree {
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

	@Private Json NodesToJson() {
		Json json = Json.parse("[]");
		for(int i = 0; i < this.nodes.getSize();i++) {
			json.add(this.nodes[i].toJson());
		}
		return json;
	}

	@Private Json LinksToJson() {
		Json json = Json.parse("[]");
		System.p(this.links.getSize());
		for(int i = 0;i < this.links.getSize();i++) {
			json.add(this.links[i].toJson());
			System.p(json);
		}
		return json;
	}

	Json toJson() {
		Json json = new Json();
		json.setString("root",this.root.name);

		json.set("childlen",this.NodesToJson());
		json.set("links",this.LinksToJson());
		return json;
	}
}

@Public class DCaseRepository {
	Tree tree;

	DCaseRepository() {
	}

	void init() {
		Goal g = new Goal();
		g.name = "it is root.";
		this.tree = new Tree(g);
	}

	void connectRepository() {
		this.init(); //FIXME
	}

	//TODO Search Argument
	Tree getTree() {
		return this.tree;
	}

	//TODO many tree
	Node[] Select(Node root, String searchText) {
	}

	Node Create(int NodeType, Json content) {
		if(NodeType == GOAL) {
			Goal node = new Goal();
			this.tree.nodes.add(node);
			return node;
		} else if (NodeType == STRATEGY) {
			Strategy node = new Strategy();
			this.tree.nodes.add(node);
			return node;
		} else if (NodeType == CONTEXT) {
			Context node = new Context();
			this.tree.nodes.add(node);
			return node;
		} else if (NodeType == EVIDENCE) {
			Evidence node = new Evidence();
			this.tree.nodes.add(node);
			return node;
		}
		return new Node();
	}

	void Insert(Node parent, Node child) {
		Link l = new Link();
		l.parent = parent;
		l.child = child;
		this.tree.links.add(l);
	}

	void Update(Node node, Json contents) {
		node.update(Json);
	}

	void Delete(Node parent, Node child) {
		this.tree.deleteLink(parent,child);
	}

}
