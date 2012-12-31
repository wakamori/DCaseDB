import("konoha.json");
import("cstyle");
import("java2.class");
import("js4.array");
import("konoha.map");
load("lib.k");

class DCaseRepository {
	Map[Argument] tree;

	void CreateArgument(String name) {
		Goal g = new Goal();
		g.name = "Root";
		this.tree.set(name,new Argument(g));
	}

	void Connect() {
		//FIXME
	}

	//TODO Search Argument
	Argument SearchArgument(String name) {
		return this.tree.get(name);
	}

	//TODO many tree & return DBNode[]
	DBNode SearchDBNode(String root, String searchText) {
		return this.SearchArgument(root).SearchDBNode(searchText);
	}

	int SearchDBNodeIndex(String root, String searchText) {
		return this.SearchArgument(root).SearchDBNodeIndex(searchText);
	}

	@Private int[] SearchLinkIndexes(String root, String searchText) {
		Link[] links = this.SearchArgument(root).links;
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
		Link[] links = this.SearchArgument(root).links;
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
			this.SearchArgument(name).Commit(CommitMethod,content);

			Goal node = new Goal(content);
			this.SearchArgument(name).nodes.add(node);
			return node;
		} else if (DBNodeType == STRATEGY) {
			content.setString("DBNodeType","STRATEGY");
			this.SearchArgument(name).Commit(CommitMethod,content);

			Strategy node = new Strategy(content);
			this.SearchArgument(name).nodes.add(node);
			return node;
		} else if (DBNodeType == CONTEXT) {
			content.setString("DBNodeType","CONTEXT");
			this.SearchArgument(name).Commit(CommitMethod,content);

			Context node = new Context(content);
			this.SearchArgument(name).nodes.add(node);
			return node;
		} else if (DBNodeType == EVIDENCE) {
			content.setString("DBNodeType","EVIDENCE");
			this.SearchArgument(name).Commit(CommitMethod,content);

			Evidence node = new Evidence(content);
			this.SearchArgument(name).nodes.add(node);
			return node;
		}
		return new DBNode(); //FIXME
	}

	void InsertLink(String name, String parent, String child) {
		Link l = new Link(parent, child);
		this.SearchArgument(name).links.add(l);
		this.SearchArgument(name).Commit("InsertLink",l.toJson());
	}

	void UpdateDBNode(String name, DBNode node, Json contents) {
		Json log = node.update(contents);
		this.SearchArgument(name).Commit("UpdateDBNode",log);
	}

	void UpdateParentLink(String name, String parent_old, String parent_new, String child) {
		int i = this.SearchLinkIndex(name, parent_old,child);
		Link l = this.SearchArgument(name).links[i];
		Json json = new Json();
		json.set("before", l.toJson());
		l.parent = parent_new;
		json.set("after", l.toJson());
		this.SearchArgument(name).Commit("UpdateParentLink",json);
	}

	void UpdateChildLink(String name, String parent, String child_old, String child_new) {
		int i = this.SearchLinkIndex(name, parent_old,child);
		Link l = this.SearchArgument(name).links[i];
		Json json = new Json();
		json.set("before", l.toJson());
		l.child = child_new;
		json.set("after", l.toJson());
		this.SearchArgument(name).Commit("UpdateChildLink",json);
	}

	@Private void _DeleteLink(Argument tree, int i) {
		Link l = tree.links[i];
		tree.Commit("DeleteLink",l.toJson());
		tree.links.removeAt(i);
	}

	void DeleteDBNode(String name, String node) {
		int[] link_idx = this.SearchLinkIndexes(name, node);
		int   node_idx = this.SearchDBNodeIndex(name, node);
		Argument t = this.SearchArgument(name);
		for(int i = 0; i < link_idx.getSize(); i++) {
			this._DeleteLink(t,link_idx[i]-i);
		}
		t.Commit("DeleteNode",t.nodes[node_idx].toJson());
		t.nodes.removeAt(node_idx);
	}

	void DeleteLink(String name, String parent, String child) {
		this._DeleteLink(this.SearchArgument(name), this.SearchLinkIndex(name, parent,child));
	}

}
