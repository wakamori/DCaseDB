import("konoha.json");
import("cstyle");
import("java2.class");
import("js4.array");
load("dbnode.k");

class LinkTree {
	String name;
	LinkTree[] children;

	LinkTree(String name) {
		this.name = name;
	}

	Json toJson() {
		Json json = new Json();
		json.setString("name",this.name);
		Json jarr = Json.parse("[]");
		for(int i = 0; i < this.children.getSize();i++) {
			jarr.add(this.children[i].toJson());
		}
		json.set("children",jarr);
		return json;
	}
}

class Argument {
	CommitLog commit_log;
	DBNode     root;
	DBNode[]   nodes;
	Link[]   links;
	Argument[] arguments;

	Argument() {
		//this.root = root;
		this.commit_log = new CommitLog();
		this.links = [];
		this.nodes = [];
		this.arguments = [];
	}

	Argument(DBNode[] nodes, Link[] links, CommitLog cl) {
		this.commit_log = cl;
		this.links = links;
		this.nodes = nodes;
		this.arguments = [];
	}

	@Private Json jsonArgument() {
		Json json = new Json();
		json.setString(JsonKeyRoot,this.root.name);
		json.set(JsonKeyNodes,this.DBNodesToJson());
		json.set(JsonKeyLinks,this.LinksToJson());
		return json;
	}

	Commit Commit(String method, Json argument) {
		return this.commit_log.addCommit(method,argument);
	}

	@Private Json DBNodesToJson() {
		Json json = Json.parse("[]");
		for(int i = 0; i < this.nodes.getSize();i++) {
			json.add(this.nodes[i].toJson());
		}
		return json;
	}

	@Private void LinkToTreeJson(String name,int index,LinkTree[] tree) {
		LinkTree[] lts = [];
		for(int i = 0;i < this.links.getSize(); i++) {
			if(name == this.links[i].parent) {
				LinkTree lt = new LinkTree(this.links[i].child);
				lts.add(lt);
			}
		}
		tree[index].children = lts;
		for(int i = 0; i < lts.getSize(); i++) {
			this.LinkToTreeJson(lts[i].name, i,lts);
		}
	}

	@Private Json LinksToJson() {
		String name = this.root.name;
		LinkTree ltroot = new LinkTree(name);
		LinkTree[] lts = [];
		for(int i = 0; i < this.links.getSize(); i++) {
			if(name == this.links[i].parent) {
				LinkTree lt = new LinkTree(this.links[i].child);
				lts.add(lt);
			}
		}
		for(int i = 0; i < lts.getSize(); i++) {
			this.LinkToTreeJson(lts[i].name, i, lts);
		}
		ltroot.children = lts;
		return ltroot.toJson();
	}

	Json toJson() {
		Json json = this.jsonArgument();
		json.set(JsonKeyCommitLog,this.commit_log.toJson());
		json.setString("HEAD", this.commit_log.head);
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

	int[] SearchLinkIndexes(String searchText) {
		int[] ret = [];
		for(int i = 0; i < this.links.getSize(); i++) {
			if(this.links[i].child == searchText) {
				ret.add(i);
			}
			if(this.links[i].parent == searchText) {
				ret.add(i);
			}
		}
		return ret;
	}

	void DeleteLink(int i) {
		Link l = this.links[i];
		this.Commit(MtdDeleteLink, l.toJson());
		this.links.removeAt(i);
	}

	int SearchLinkIndex(String parent, String child) {
		for(int i = 0; i < this.links.getSize(); i++) {
			if(this.links[i].child == child && this.links[i].parent == parent) {
				return i;
			}
		}
		return -1;
	}

	void UpdateLink(int is_child,String parent, String newId, String child) {
		int i = this.SearchLinkIndex(parent,child);
		Link l = this.links[i];
		Json json = new Json();
		json.set("before", l.toJson());
		if(is_child == 0) {
			l.parent = newId;
		}else{
			l.child  = newId;
		}
		json.set("after", l.toJson());
		this.Commit(MtdUpdateLink,json);
	}
}

