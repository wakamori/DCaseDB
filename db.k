import("konoha.json");
import("cstyle");
import("java2.class");
import("js4.array");
import("konoha.map");
load("argument.k");

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
		Argument argument = this.SearchArgument(name);
		Link l = new Link(parent, child);
		argument.links.add(l);
		argument.Commit("InsertLink",l.toJson());
	}

	void UpdateDBNode(String name, DBNode node, Json contents) {
		this.SearchArgument(name).Commit("UpdateDBNode", node.update(contents));
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
		argument.Commit("DeleteNode",argument.nodes[node_idx].toJson());
		argument.nodes.removeAt(node_idx);
	}

	void DeleteLink(String name, String parent, String child) {
		Argument argument = this.SearchArgument(name);
		argument.DeleteLink(argument.SearchLinkIndex(parent,child));
	}

	//TODO
	Json ShowRevision(String name, String revision) {
		Argument argument = this.SearchArgument(name);
		return argument.toJson();
	}
}
