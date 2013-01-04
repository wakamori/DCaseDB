import("konoha.json");
import("cstyle");
import("java2.class");
import("js4.array");
load("dbnode.k");

class Argument {
	CommitLog commit_log;
	DBNode     root;
	DBNode[]   nodes;
	Link[]   links;
	Argument[] arguments;

	Argument(Goal root) {
		this.root = root;
		this.commit_log = new CommitLog();
		this.links = [];
		this.nodes = [];
		this.arguments = [];
	}

	@Private Json jsonArgument() {
		Json json = new Json();
		json.setString(JsonKeyRoot,this.root.name);
		json.set(JsonKeyNodes,this.DBNodesToJson());
		json.set(JsonKeyLinks,this.LinksToJson());
		return json;
	}

	String Commit(String method, Json argument) {
		return this.commit_log.addCommit(method,argument);
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

