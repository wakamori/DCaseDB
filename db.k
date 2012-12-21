import("konoha.const");
import("konoha.global");
import("konoha.json");
import("openssl");
import("konoha.foreach");
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
}

@Public class Link {
	Node parent;
	Node child;
}

@Public class Context extends Node {
	Json condition;
}

@Public class Goal extends Node {
	Context context;
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

	Json toJson() {
		Json j = new Json();
		for(Node it in this.nodes) {
			j.setString("text",it.name);
		}
		j.setString("root",this.root.name);
		return j;
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
			return new Goal(content);
		} else if (NodeType == STARTEGY) {
			return new Strategy();
		} else if (NodeType == CONTEXT) {
			return new Context();
		} else if (NodeType == EVIDENCE) {
			return new Evidence();
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
