//import("konoha.ns");
//import("konoha.json");
//import("openssl");
//import("cstyle");
//import("java2.class");
//import("konoha.map");
//import("konoha.sql");
//import("konoha.object");
//import("js4.array");
//import("js4.date");

Import("Type.Json");
Import("Lib.Openssl");
Import("Syntax.CStyleFor");
Import("Syntax.CStyleWhile");
Import("Syntax.Null");
Import("Java.Class");
Import("MiniKonoha.NameSpace");
Import("MiniKonoha.Map");
Import("MiniKonoha.Sql");
Import("JavaStyle.Object");
Import("JavaScript.Array");
Import("JavaScript.Date");

class DBNode {
	String nodeId;
	String description;
	String argumentId;
	String branchId;
	boolean isEvidence;

	//String parentId;
	DBNode parent;
	//String[] childIds;
	DBNode[] children;

	DBNode(String nodeId, String description, boolean isEvidence) {
		this.nodeId      = nodeId;
		this.description = description;
		this.isEvidence  = isEvidence;
		this.children    = [];
	}

	DBNode(String nodeId, String description) {
		this.nodeId      = nodeId;
		this.description = description;
		this.isEvidence  = false;
		this.children    = [];
	}

	DBNode(String nodeId) {
		this.nodeId      = nodeId;
		this.description = "";
		this.isEvidence  = false;
		this.children    = [];
	}

	DBNode(Json content) {
		this.nodeId      = "";
		this.description = "";
		this.isEvidence  = false;
		this.children    = [];
		this.PrivateUpdate(content);
	}

	void AddChild(DBNode child) {
		this.children.add(child);
		child.parent = this;
	}

	void RemoveChild(DBNode child) {
		for(int i = 0; i < this.children.getSize(); i = i + 1) {
			if(this.children[i].nodeId == child.nodeId){
				children.removeAt(i);
				break;
			}
		}
		child.parent = NULL;
	}

	void AddParent(DBNode parent) {
		this.parent = parent;
		parent.children.add(this);
	}

	//Private
	void PrivateUpdate(Json content) {
		if(content.hasKey("nodeId")) {
			this.nodeId = content.getString("nodeId");
		}
		if(content.hasKey("description")) {
			this.description = content.getString("description");
		}
		if(content.hasKey("isEvidence")) {
			this.isEvidence = content.getBoolean("isEvidence");
		}
	}

	Json Update(Json content) {
		Json json = new Json();
		json.set("before",this.toJson());
		this.PrivateUpdate(content);
		json.set("after", this.toJson());
		return json;
	}

	Json PrivateToJson() {
		Json json = new Json();
		json.setString("nodeId",this.nodeId);
		json.setString("description",this.description);
		json.setBoolean("isEvidence",this.isEvidence);
		return json;
	}

	Json toJson() {
		Json json = this.PrivateToJson();
		return json;
	}

	Json GetContext() {
		//Abstract
		return NULL;
	}

	void AddContext(Json context) {
		//Abstract
	}
}

class Context extends DBNode {
	Json context; //FIXME

	Context(Json content) {
		//TODO Create Argument
		this.context = new Json();

		this.PrivateUpdate(content);
		if(content.hasKey("context")) {
			Json array = content.get("context");
			String[] keys = array.keys();
			for(int i = 0; i < keys.getSize(); i = i + 1) {
				this.context.setString(keys[i],array.getString(keys[i]));//TODO validation
			}
		}
	}

	String searchValue(String key) {
		if(this.context.hasKey(key)) {
			return this.context.getString(key);
		}
		return NULL;
	}

	void addKeyValue(String key, String value) {
		this.context.setString(key,value);
	}

	Json toJson() {
		Json json = this.PrivateToJson();
		json.setString("DBNodeType","Context");
		json.set("context",this.context);
		return json;
	}

	Json GetContext() {
		return this.context;
	}

	void AddContext(Json context) {
		String[] keys = context.keys();
		for(int i = 0; i < keys.getSize(); i = i + 1) {
			this.context.setString(keys[i],context.getString(keys[i])); //TODO Need validation
		}
	}
}

class Goal extends DBNode {
	Goal(){}

	Json toJson() {
		Json json = this.PrivateToJson();
		json.setString("DBNodeType","Goal");
		return json;
	}

	//FIXME validation
	Json GetContext() {
		Json json = this.parent.GetContext();
		Json context_array = Json.parse("[]");
		for(int i = 0; i < this.children.getSize();i = i + 1) {
			if(this.children[i].toJson().getString("DBNodeType") == "Context") { //FIXME instanceOf
				Context c = this.children[i] as Context;
				context_array.add(c.GetContext());
			}
		}
		for(int i = 0; i < context_array.getSize();i = i + 1) {
			Json context = context_array.get(i);
			String[] keys = context.keys();
			for(int j = 0; j < keys.getSize(); j = j + 1) {
				json.setString(keys[i],context.getString(keys[i]));
			}
		}
		return json;
	}

	void AddContext(Json context) {
		for(int i = 0; i < this.children.getSize();i = i + 1) {
			if(this.children[i].toJson().getString("DBNodeType") == "Context") { //FIXME instanceOf
				Context c = this.children[i] as Context;
				c.AddContext(context);
				return;
			}
		}
		//FIXME if there is no Context, add new Context(not here?)
	}
}

class Strategy extends DBNode {
	Strategy(){}

	Json toJson() {
		Json json = this.PrivateToJson();
		json.setString("DBNodeType","Strategy");
		return json;
	}

	//FIXME validation
	Json GetContext() {
		Json json = this.parent.GetContext();
		Json context_array = Json.parse("[]");
		for(int i = 0; i < this.children.getSize();i = i + 1) {
			if(this.children[i].toJson().getString("DBNodeType") == "Context") { //FIXME instanceOf
				Context c = this.children[i] as Context;
				context_array.add(c.GetContext());
			}
		}
		for(int i = 0; i < context_array.getSize();i = i + 1) {
			Json context = context_array.get(i);
			String[] keys = context.keys();
			for(int j = 0; j < keys.getSize(); j++) {
				json.setString(keys[i],context.getString(keys[i]));
			}
		}
		return json;
	}

	void AddContext(Json context) {
		for(int i = 0; i < this.children.getSize();i = i + 1) {
			if(this.children[i].toJson().getString("DBNodeType") == "Context") { //FIXME instanceOf
				Context c = this.children[i] as Context;
				c.AddContext(context);
				break;
			}
		}
	}
}

class Evidence extends DBNode {
	Evidence() {}

	Json toJson() {
		Json json = this.PrivateToJson();
		json.setString("DBNodeType","Evidence");
		return json;
	}

	Json GetContext(){
		return this.parent.GetContext();
	}
}

//TODO
class Justification extends DBNode {
	Justification(){}

	Json toJson() {
		Json json = this.PrivateToJson();
		json.setString("DBNodeType","Justification");
		return json;
	}
}

//TODO
class Rebuttal extends DBNode {
	Rebuttal(){}

	Json toJson() {
		Json json = this.PrivateToJson();
		json.setString("DBNodeType","Rebuttal");
		return json;
	}
}

class Commit {
	String method;
	Json   args;
	String revision;
	int time;

	Commit() {
	}

	Commit(String method, Json args, String revision) {
		this.method   = method;
		this.args     = args;
		this.revision = revision;
		this.time     = new Date().getTime();
	}

	Json toJson() {
		Json json = new Json();
		json.setString("method",this.method);
		json.set("args",this.args);
		json.setString("revision",this.revision);
		json.setInt("time",this.time);
		return json;
	}
}

class CommitLog {
	Commit[] commits;
	String head;
	SHA1 sha1;

	CommitLog() {
		this.commits = [];
		this.sha1 = new SHA1();
		this.sha1.update(new Date().toString());
	}

	Commit addCommit(String method, Json argument) {
		Commit commit = new Commit(method, argument, this.sha1.final());
		this.commits.add(commit);
		this.head = commit.revision;
		return commit;
	}

	Json toJson() {
		Json json = Json.parse("[]");
		for(int i = 0;i < this.commits.getSize(); i = i + 1) {
			json.add(this.commits[i].toJson());
		}
		return json;
	}

}

class Branch {
	String branchId;
	DBNode root;
	DBNode[] nodes;

	Branch() {
		this.root = NULL;
		this.nodes = [];
	}

	Branch(DBNode[] nodes, DBNode root) {
		this.nodes = nodes;
		this.root = root;
	}

	DBNode GetDBNode(String nodeId) {
		if(this.root.nodeId == nodeId) {
			return this.root;
		}
		int i = 0;
		for(int i = 0; i < this.nodes.getSize(); i = i + 1) {
			System.p(nodeId == this.nodes[i].nodeId);
			if(this.nodes[i].nodeId == nodeId) {
				System.p("GetDBNode:"+nodeId);
				return this.nodes[i];
			}
		}
		return NULL;
	}

	Json DBNodeListToJson() {
		Json json = Json.parse("[]");
		int max = this.nodes.getSize();
		//for(int i = 0; i < max; i = i + 1) {
		int i = 0;
		while(i < max) {
			json.add(this.nodes[i].toJson());
			i = i + 1;
		}
		return json;
	}

	Json PrivateArgumentTreeToJson(DBNode node) {
		Json json = new Json();
		json.setString("name",node.nodeId);
		Json children = Json.parse("[]");
		//for(int i = 0; i < node.children.getSize(); i = i + 1) {
		int i = 0;
		while(i < node.children.getSize()) {
			children.add(this.PrivateArgumentTreeToJson(node.children[i]));
			i = i + 1;
		}
		json.set("children",children);
		return json;
	}

	Json ArgumentTreeToJson() {
		Json json = new Json();
		json.setString("name",this.root.nodeId);
		Json children = Json.parse("[]");
		//for(int i = 0; i < this.root.children.getSize(); i = i + 1) {
		int i = 0;
		while(i < this.root.children.getSize()) {
			children.add(this.PrivateArgumentTreeToJson(this.root.children[i]));
			i = i + 1;
		}
		json.set("children",children);
		return json;
	}

	void RemoveNode(DBNode node) {
		//for(int i = 0; i < this.nodes.getSize(); i = i + 1) {
		int i = 0;
		while(i < this.nodes.getSize()) {
			if(node.nodeId == this.nodes[i].nodeId) {
				this.nodes.removeAt(i);
				break;
			}
			i = i + 1;
		}
	}

	@Public Json toJson() {
		Json json = new Json();
		json.set("root",this.root.toJson());
		json.set("nodes",this.DBNodeListToJson());
		json.set("links",this.ArgumentTreeToJson());
		return json;
	}
}

class Argument {
	String argumentId;
	Map[Branch] branches;
	Map[CommitLog] commits;

	Argument() {
		this.branches = new Map[Branch];
		this.branches.set("master", new Branch());
		this.commits.set("master", new CommitLog());
	}

	Commit Commit(String method, Json argument) {
		return this.commits.addCommit(method,argument);
	}

	@Public Branch GetBranch(String BranchId) {
		return this.branches.get(BranchId);
	}

	@Public Branch Fork(String originId, String newId, Context ctx) {
		this.Fork(originId, newId, ctx, this.GetBranch(originId).commitLog.head);
	}

	@Public Branch Fork(String originalId, String newId, Context ctx, String revision) {
		return new Branch(); //FIXME
	}

	DBNode GetDBNode(String nodeId) {
		return this.GetDBNode("master",nodeId);
	}

	DBNode GetDBNode(String branchId, String nodeId) {
		return this.GetBranch(branchId).GetDBNode(nodeId);
	}

	void SetRoot(Goal g) {
		this.SetRoot("master",g);
	}

	void SetRoot(String branchId, Goal g) {
		this.GetBranch(branchId).root = g;
	}

	Json toJson(String branchName) {
		Json json = this.GetBranch(branchName).toJson();
		CommitLog clog = this.commits.get(branchName);
		json.set("CommitLog",clog.toJson());
		json.setString("HEAD",clog.head);
		json.setString("argumentId",this.argumentId);
		json.setString("branchId",branchName);
		return json;
	}

	Json toJson() {
		return this.toJson("master");
	}
}

class DBDriver {
	DBDriver(){}

	Json getContext(int id) {
	}

	Argument GetArgument(int argumentId) {
	}

	//TODO args
	Argument CreateArgument() {
	}

	//DBNode
	DBNode CreateDBNode(String nodeType, Json content) {
	}

	//TODO
	//void InsertCommit(String argument_name, String method, Commit c) {
	//}

	void InsertLink(int argumentId, int parentId, int childId) {
	}

	void addContext(int argumentId, int contextId, Json context) {
	}
}

class DriverMySQL extends DBDriver {
	Connection con;

	DriverMySQL(String userName, String password) {
		this.con = new Connection("mysql://" + userName + ":" + password + "@localhost:3306");
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
}

class API {
	Map[Argument] arguments;
	DBDriver db;

	API() {
		arguments = new Map[Argument];
	}

	API(String userName, String password) {
		this.Connect(userName, password);
	}

	void Connect(String userName, String password) {
		this.db = new DriverMySQL(userName, password);
	}

	@Public Argument CreateArgument(String argumentId, String description) {
		Json content = new Json();
		content.setString("nodeId",argumentId);
		content.setString("description",description);
		content.setString("DBNodeType","Goal");

		this.arguments.set(argumentId, new Argument());
		Argument argument = this.arguments.get(argumentId);
		argument.argumentId = argumentId;

		Goal g = this.CreateDBNode(argumentId,content) as Goal;
		argument.SetRoot(g);
	}

	@Public Argument GetArgument(String argumentId) {
		return this.arguments.get(argumentId);
	}

	@Public String[] GetArgumentIds() {
		return this.arguments.keys(); //FIXME
	}

	@Public DBNode[] SearchDBNode(String searchText) {
		return []; //FIXME
	}

	@Public DBNode CreateDBNode(String argumentId, Json content) {
		String NodeType = content.getString("DBNodeType");
		if(NodeType == "Goal") {
			Goal node = new Goal(content);
			return node;
		} else if (NodeType == "Strategy") {
			Strategy node = new Strategy(content);
			return node;
		} else if (NodeType == "Context") {
			Context node = new Context(content);
			return node;
		} else if (NodeType == "Evidence") {
			Evidence node = new Evidence(content);
			return node;
		} else if (NodeType == "Justification") {
			Justification node = new Justification(content);
			return node;
		} else if (NodeType == "Rebuttal") {
			Rebuttal node = new Rebuttal(content);
			return node;
		}
		return NULL;
	}

	@Public void InsertLink(String argumentId, DBNode parentId, DBNode childId) {
		this.InsertLink(argumentId, "master", parentId, childId);
	}

	@Public void InsertLink(String argumentId, String branchId, DBNode parent, DBNode child) {
		Branch branch = this.GetArgument(argumentId).GetBranch(branchId);
		branch.nodes.add(parent);
		branch.nodes.add(child);
		parent.addChild(child);
		//TODO Commit
	}

	//FIXME Json contents
	@Public void UpdateDBNode(String argumentId, DBNode node, Json contents) {
		this.UpdateDBNode(argumentId,"master",node,contents);
	}

	@Public void UpdateDBNode(String argumentId, String branchId, DBNode node, Json contents) {
		node.Update(contents);
		//TODO Commit Log
	}

	@Public void UpdateParentLink(DBNode oldParent, DBNode newParent, DBNode node) {
		oldParent.RemoveChild(node);
		newParent.AddChild(node);
	}

	@Public void UpdateChildLink(DBNode node, DBNode oldChild, DBNode newChild) {
		node.RemoveChild(oldChild);
		node.AddChild(newChild);
	}

	@Public void DeleteDBNode(String argumentId, String nodeId) {
		this.DeleteDBNode(argumentId, "master", nodeId);
	}

	@Public void DeleteDBNode(String argumentId, String branchId, String nodeId) {
		Branch branch = this.GetArgument(argumentId).GetBranch(branchId);
		DBNode node = branch.GetDBNode(ndoeId);
		branch.RemoveNode(node);
	}

	@Public void DeleteLink(String argumentId, String parentId, String childId) {
		this.DeleteLink(argumentId, "master", parentId, childId);
	}

	@Public void DeleteLink(String argumentId, String branchId, String parentId, String childId) {
		//TODO
	}

	@Public void AddContext(String argumentId, String nodeId, Json context) {
		this.AddContext(argumentId, "master", nodeId, context);
	}

	@Public void AddContext(String argumentId, String branchId, String nodeId, Json context) {
		DBNode node = this.GetArgument(argumentId).GetBranch(branchId).GetDBNode(nodeId);
		node.addContext(context);
	}
}
