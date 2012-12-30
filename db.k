import("konoha.ns");
import("konoha.global");
import("konoha.json");
import("openssl");
import("cstyle");
import("java2.class");
import("js4.array");
import("js4.date");
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

	DBNode SearchDBNode(String search) {
		for(int i = 0; i < this.nodes.getSize(); i++) {
			if(this.nodes[i].name == search) {
				return this.nodes[i];
			}
		}
		return NULL;
	}

	int SearchDBNodeIndex(String search) {
		for(int i = 0; i < this.nodes.getSize(); i++) {
			if(this.nodes[i].name == search) {
				return i;
			}
		}
		return -1;
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
		return this.SearchTree(root).SearchDBNode(searchText);
	}

	int SearchDBNodeIndex(String root, String searchText) {
		return this.SearchTree(root).SearchDBNodeIndex(searchText);
	}

	@Private int[] SearchLinkIndexes(String root, String searchText) {
		Link[] links = this.SearchTree(root).links;
		int[] ret = [];
		for(int i = 0; i < links.getSize(); i++) {
			if(links[i].child == searchText) {
				ret.add(i);
			}
			if(links[i].parent == searchText) {
				ret.add(i);
			}
		}
		return ret;
	}

	@Private int SearchLinkIndex(String root, String parent, String child) {
		Link[] links = this.SearchTree(root).links;
		for(int i = 0; i < links.getSize(); i++) {
			if(links[i].child == child && links[i].parent == parent) {
				return i;
			}
		}
		return -1;
	}

	DBNode CreateDBNode(String name, int DBNodeType, Json content) {
		String CommitMethod = "CreateDBNode";
		if(DBNodeType == GOAL) {
			content.setString("DBNodeType","GOAL");
			this.SearchTree(name).Commit(CommitMethod,content);

			Goal node = new Goal(content);
			this.SearchTree(name).nodes.add(node);
			return node;
		} else if (DBNodeType == STRATEGY) {
			content.setString("DBNodeType","STRATEGY");
			this.SearchTree(name).Commit(CommitMethod,content);

			Strategy node = new Strategy(content);
			this.SearchTree(name).nodes.add(node);
			return node;
		} else if (DBNodeType == CONTEXT) {
			content.setString("DBNodeType","CONTEXT");
			this.SearchTree(name).Commit(CommitMethod,content);

			Context node = new Context(content);
			this.SearchTree(name).nodes.add(node);
			return node;
		} else if (DBNodeType == EVIDENCE) {
			content.setString("DBNodeType","EVIDENCE");
			this.SearchTree(name).Commit(CommitMethod,content);

			Evidence node = new Evidence(content);
			this.SearchTree(name).nodes.add(node);
			return node;
		}
		return new DBNode(); //FIXME
	}

	void InsertLink(String name, String parent, String child) {
		Link l = new Link(parent, child);
		this.SearchTree(name).links.add(l);
		this.SearchTree(name).Commit("InsertLink",l.toJson());
	}

	void UpdateDBNode(String name, DBNode node, Json contents) {
		Json log = node.update(contents);
		this.SearchTree(name).Commit("UpdateDBNode",log);
	}

	void UpdateParentLink(String name, String parent_old, String parent_new, String child) {
		int i = this.SearchLinkIndex(name, parent_old,child);
		Link l = this.SearchTree(name).links[i];
		Json json = new Json();
		json.set("before", l.toJson());
		l.parent = parent_new;
		json.set("after", l.toJson());
		this.SearchTree(name).Commit("UpdateParentLink",json);
	}

	void UpdateChildLink(String name, String parent, String child_old, String child_new) {
		int i = this.SearchLinkIndex(name, parent_old,child);
		Link l = this.SearchTree(name).links[i];
		Json json = new Json();
		json.set("before", l.toJson());
		l.child = child_new;
		json.set("after", l.toJson());
		this.SearchTree(name).Commit("UpdateChildLink",json);
	}

	@Private void _DeleteLink(Tree tree, int i) {
		Link l = tree.links[i];
		tree.Commit("DeleteLink",l.toJson());
		tree.links.removeAt(i);
	}

	void DeleteDBNode(String name, String node) {
		int[] link_idx = this.SearchLinkIndexes(name, node);
		int   node_idx = this.SearchDBNodeIndex(name, node);
		Tree t = this.SearchTree(name);
		for(int i = 0; i < link_idx.getSize(); i++) {
			this._DeleteLink(t,link_idx[i]-i);
		}
		t.Commit("DeleteNode",t.nodes[node_idx].toJson());
		t.nodes.removeAt(node_idx);
	}

	void DeleteLink(String name, String parent, String child) {
		this._DeleteLink(this.SearchTree(name), this.SearchLinkIndex(name, parent,child));
	}

}
