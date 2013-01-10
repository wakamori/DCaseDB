import("konoha.json");
import("cstyle");
import("java2.class");
import("js4.array");
import("konoha.map");
import("konoha.object");
load("argument.k");
load("constString.k");
load("dcasemysql.k");

class DCaseDB {
	Map[Argument] tree;
	DBDriver db;

	void CreateArgument(String name,String description) {
		int id = this.db.CreateArgument(name);
		Json content = new Json();
		content.setString("name",name);
		content.setString("description",description);
		content.setString("DBNodeType","Goal");

		this.tree.set(name,new Argument());
		Argument argument = this.tree.get(name);
		Commit c = argument.Commit("CreateArgument",content);
		this.db.InsertCommit(name,"CreateArgument",c);

		Goal g = this.CreateDBNode(name,content) as Goal;
		argument.root = g;
		this.db.addArgumentRoot(name,id);
	}

	void Connect(String name, String passwd) {
		this.db = new DBDriver(name,passwd);
	}

	//TODO Search Argument
	Argument SearchArgument(String name) {
		if(this.tree.has(name)) {
			return this.tree.get(name);
		} else {
			Argument a = this.db.SearchArgument(name);
			this.tree.set(name,a);
			return a;
		}
	}

	//TODO many tree & return DBNode[]
	DBNode SearchDBNode(String root, String searchText) {
		return this.SearchArgument(root).SearchDBNode(searchText);
	}

	DBNode CreateDBNode(String name, Json content) {
		Argument argument = this.SearchArgument(name);
		String NodeType = content.getString(JsonKeyDBNodeType);
		if(NodeType == NodeTypeGoal) {
			Commit c = argument.Commit(MtdCreateDBNode,content);
			this.db.CreateDBNode(name,NodeType,content);
			this.db.InsertCommit(name,MtdCreateDBNode,c);

			Goal node = new Goal(content);
			argument.nodes.add(node);
			return node;
		} else if (NodeType == NodeTypeStrategy) {
			Commit c = argument.Commit(MtdCreateDBNode,content);
			this.db.CreateDBNode(name,NodeType,content);
			this.db.InsertCommit(name,MtdCreateDBNode,c);

			Strategy node = new Strategy(content);
			argument.nodes.add(node);
			return node;
		} else if (NodeType == NodeTypeContext) {
			Commit c = argument.Commit(MtdCreateDBNode,content);
			this.db.CreateDBNode(name,NodeType,content);
			this.db.InsertCommit(name,MtdCreateDBNode,c);

			Context node = new Context(content);
			argument.nodes.add(node);
			return node;
		} else if (NodeType == NodeTypeEvidence) {
			Commit c = argument.Commit(MtdCreateDBNode,content);
			this.db.CreateDBNode(name,NodeType,content);
			this.db.InsertCommit(name,MtdCreateDBNode,c);

			Evidence node = new Evidence(content);
			argument.nodes.add(node);
			return node;
		}
		return NULL; //FIXME
	}

	void InsertLink(String name, String parent, String child) {
		Argument argument = this.SearchArgument(name);
		this.db.InsertLink(name,parent,child);
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

	void AddContext(String argument_name, String context_name, Json context) {
		Argument argument = this.SearchArgument(argument_name);
		Context c = argument.SearchDBNode(context_name);
		c.addKeyValue(context);
		argument.Commit("AddContext",context); //FIXME
		this.db.addContext(argument_name,context_name,context);
	}
}
