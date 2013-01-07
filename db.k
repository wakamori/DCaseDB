import("konoha.json");
import("cstyle");
import("java2.class");
import("js4.array");
import("konoha.map");
load("argument.k");
load("constString.k");

class DCaseDB {
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

	DBNode CreateDBNode(String name, Json content) {
		Argument argument = this.SearchArgument(name);
		String NodeType = content.getString(JsonKeyDBNodeType);
		if(NodeType == NodeTypeGoal) {
			argument.Commit(MtdCreateDBNode,content);

			Goal node = new Goal(content);
			argument.nodes.add(node);
			return node;
		} else if (NodeType == NodeTypeStrategy) {
			argument.Commit(MtdCreateDBNode,content);

			Strategy node = new Strategy(content);
			argument.nodes.add(node);
			return node;
		} else if (NodeType == NodeTypeContext) {
			argument.Commit(MtdCreateDBNode,content);

			Context node = new Context(content);
			argument.nodes.add(node);
			return node;
		} else if (NodeType == NodeTypeEvidence) {
			argument.Commit(MtdCreateDBNode,content);

			Evidence node = new Evidence(content);
			argument.nodes.add(node);
			return node;
		}
		return NULL; //FIXME
	}

	void InsertLink(String name, String parent, String child) {
		Argument argument = this.SearchArgument(name);
		Link l = new Link(parent, child);
		argument.links.add(l);
		argument.Commit(MtdInsertLink,l.toJson());
	}

	void UpdateDBNode(String name, DBNode node, Json contents) {
		this.SearchArgument(name).Commit(MtdUpdateDBNode, node.update(contents));
	}

	void UpdateParentLink(String name, String parent_old, String parent_new, String child) {
		this.SearchArgument(name).UpdateLink(0,parent_old,parent_new,child);
	}

	void UpdateChildLink(String name, String parent, String child_old, String child_new) {
		this.SearchArgument(name).UpdateLink(1,parent,child_new,child_old);
	}

	void DeleteDBNode(String name, String node) {
		Argument argument = this.SearchArgument(name);
		int[] link_idx = argument.SearchLinkIndexes(node);
		int   node_idx = argument.SearchDBNodeIndex(node);
		for(int i = 0; i < link_idx.getSize(); i++) {
			argument.DeleteLink(link_idx[i]-i); //FIXME
		}
		argument.Commit(MtdDeleteDBNode,argument.nodes[node_idx].toJson());
		argument.nodes.removeAt(node_idx);
	}

	void DeleteLink(String name, String parent, String child) {
		Argument argument = this.SearchArgument(name);
		argument.DeleteLink(argument.SearchLinkIndex(parent,child));
	}

	//TODO
	Json ShowRevision(String name, String revision) {
		Argument argument = this.SearchArgument(name);
		return this.useCommitLog(argument);
	}

	Json useCommitLog(Argument argument) {
		Json json = argument.toJson();
		Json commitlog = json.get(JsonKeyCommitLog);
		for(int i = 0; i < commitlog.getSize(); i++) {
			System.p(commitlog.get(i).getString("method"));
		}
		return json;
	}
}
