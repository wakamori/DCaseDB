import("konoha.json");
import("cstyle");
import("java2.class");
import("js4.array");
import("konoha.map");
import("konoha.sql");
import("konoha.object");

class DBDriver {
	Connection con;

	DBDriver(String name, String passwd) {
		this.con = new Connection("mysql://" + name + ":" + passwd + "@localhost:3306");
		this.con.query("USE dcasedb;");
	}


	DBNode MakeNode(String NodeType) {
		if(NodeType == NodeTypeGoal) {
			return new Goal();
		} else if (NodeType == NodeTypeStrategy) {
			return new Strategy();
		} else if (NodeType == NodeTypeContext) {
			return new Context();
		} else if (NodeType == NodeTypeEvidence) {
			return new Evidence();
		}
		return new DBNode();
	}

	Json getContext(int id) {
		Json json = new Json();
		ResultSet r = this.con.query("SELECT context_key,value FROM Context WHERE node_id="+id);
		if(r.getSize() > 0) {
			while(r.next()) {
				String key = r.getString("context_key");
				String value = r.getString("value");
				json.setString(key,value);
			}
		}
		return json;
	}

	DBNode[] getDBNodeList(int argument_id) {
		ResultSet r = this.con.query("SELECT DBNode.id,name,description,evidence_flag,type_name FROM DBNode,NodeType WHERE argument_id="+argument_id+" AND nodeType_id=NodeType.id;");
		DBNode[] nodes = [];
		while(r.next()) {
			String type = r.getString("type_name");
			DBNode node = this.MakeNode(type);
			node.name = r.getString("name");
			node.description = r.getString("description");
			node.is_evidence = r.getBoolean("evidence_flag");
			if(type == "Context") {
				Context context = node as Context;
				context.condition = this.getContext(r.getInt("id"));
				nodes.add(context);
			} else {
				nodes.add(node);
			}
		}
		return nodes;
	}

	Link[] getLinksList(int argument_id) {
		ResultSet r = this.con.query("SELECT parent.name AS parent_name,child.name AS child_name FROM NodeLink INNER JOIN DBNode AS parent ON NodeLink.parent_Node_id=parent.id INNER JOIN DBNode AS child ON NodeLink.child_Node_id=child.id WHERE NodeLink.argument_id=" + argument_id);
		Link[] links = [];
		while(r.next()) {
			Link l = new Link();
			l.parent = r.getString("parent_name");
			l.child = r.getString("child_name");
			links.add(l);
		}
		return links;
	}

	CommitLog getCommitLog(int argument_id) {
		ResultSet r = this.con.query("SELECT method,args,revision,time FROM Commit WHERE argument_id=" + argument_id);
		Commit[] commits = [];
		while(r.next()) {
			Commit c = new Commit();
			c.method = r.getString("method");
			c.argument = Json.parse(r.getString("args"));
			c.revision = r.getString("revision");
			c.time     = r.getInt("time");
			commits.add(c);
		}
		CommitLog cl = new CommitLog();
		cl.commits = commits;
		cl.head    = commits[commits.getSize()-1].revision;
		return cl;
	}

	Argument SearchArgument(String name) {
		int argument_id = this.getArgumentId(name);

		DBNode[] nodes = this.getDBNodeList(argument_id);
		Link[]   links = this.getLinksList(argument_id);
		CommitLog clog = this.getCommitLog(argument_id);
		//FIXME
		DBNode n;
		for(int i = 0; i < nodes.getSize(); i++) {
			if(nodes[i].name == name) {
				n = nodes[i];
			}
		}
		return new Argument(nodes,links,clog,n);
	}

	int CreateArgument(String name) {
		this.con.query("INSERT INTO Argument(name) VALUES('"+name+"')");
		return this.con.getInsertId();
	}

	void addArgumentRoot(String name, int id) {
		int nodeid = this.getDBNodeId(name);
		this.con.query("UPDATE Argument SET goal_id=" + nodeid +" WHERE id=" + id);
	}

	int getArgumentId(String name) {
		ResultSet argumentId = this.con.query("SELECT id FROM Argument WHERE name='" + name+"'");
		int id;
		while(argumentId.next()) {
			id = argumentId.getInt("id");
		}
		return id;
	}

	int getDBNodeId(String name) { //FIXME Argument_name
		ResultSet nodeId = this.con.query("SELECT id FROM DBNode WHERE name='" + name + "'");
		int id;
		while(nodeId.next()) {
			id = nodeId.getInt("id");
		}
		return id;
	}

	void InsertCommit(String argument_name, String method, Commit c) {
		int id = this.getArgumentId(argument_name);
		this.con.query("INSERT INTO Commit(method,args,argument_id,revision,time) VALUES ('"+ method +"','" + c.argument + "'," + id + ",'"+c.revision+"',"+ c.time +")");
	}

	void CreateDBNode(String name,String nodeType,Json content) {
		ResultSet nodeTypeId = this.con.query("SELECT id FROM NodeType WHERE type_name='" + nodeType + "'");
		int nodeId;
		while(nodeTypeId.next()) {
			nodeId = nodeTypeId.getInt("id");
		}
		int argument_id     = this.getArgumentId(name);
		String nodeName     = content.getString("name");
		String description  = content.getString("description");
		boolean is_evidence = content.getBoolean("is_evidence");
		this.con.query("INSERT INTO DBNode(name,description,evidence_flag,nodeType_id,argument_id) VALUES('" + nodeName +"','"+ description + "','" + is_evidence + "',"+nodeId+"," + argument_id +") ");
	}

	void InsertLink(String argument_name, String parent_name, String child_name) {
		int argument_id = this.getArgumentId(argument_name);
		int parent_id   = this.getDBNodeId(parent_name);
		int child_id    = this.getDBNodeId(child_name);
		this.con.query("INSERT INTO NodeLink(argument_id,parent_Node_id,child_Node_id) VALUES('"+argument_id+"','"+parent_id+"','"+child_id+"')");
	}

	void addContext(String argument_name, String context_name, Json context) {
		int argument_id     = this.getArgumentId(name);
		int context_id      = this.getDBNodeId(context_name);
		String[] keys = context.keys();
		for(int i = 0; i<keys.getSize();i++) {
			String key = keys[i];
			this.con.query("INSERT INTO Context(context_key,value,node_id) Values('"+ key +"','" +context.getString(key)+ "'," +context_id+ ")");
		}
	}
}
