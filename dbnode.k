import("konoha.ns");
import("konoha.json");
import("openssl");
import("cstyle");
import("java2.class");
import("js4.array");
import("js4.date");

const NODE = 0;
const GOAL = 1;
const STRATEGY = 2;
const CONTEXT = 3;
const EVIDENCE = 4;

class DBNode {
	String  name;
	String  description;
	boolean is_evidence;
	//boolean is_consensus;

	DBNode(Json content) {
		this.updateContent(content);
	}

	Json _toJson() {
		Json json = new Json();
		json.setString("name",this.name);
		json.setString("description",this.description);
		json.setBoolean("is_evidence",this.is_evidence);
		return json;
	}

	Json toJson() {
		return this._toJson();
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

	Link(Json content) {
		if(content.hasKey("parent")) {
			this.parent = content.getString("parent");
		}
		if(content.hasKey("child")) {
			this.child  = content.getString("child");
		}
	}

	//TODO LinktoTreeJson
	Json toJson() {
		Json json = new Json();
		json.setString("parent",this.parent);
		json.setString("child",this.child);
		return json;
	}
}

class Context extends DBNode {
	Json condition;
	Context(Json content) {
		//TODO Create Argument
		this.condition = Json.parse("[]"); //FIXME?
		this.updateContent(content);
		if(content.hasKey("condition")) {
			Json array = content.get("condition");
			for(int i = 0; i < array.getSize(); i++) {
				this.condition.add(array.get(i)); //TODO Need validation
			}
		}
	}

	String searchValue(String key) {
		if(this.condition.hasKey(key)) {
			return this.condition.getString(key);
		}
		return NULL;
	}

	void addKeyValue(Json json) {
		this.condition.add(json);
	}
}

//TODO
class Goal extends DBNode {
	Context context; //FIXME Why need this?
	Goal(Json content, Context context) {
		this.updateContent(content);
		this.context = context;
	}
}

class Strategy extends DBNode {
	Context context;
	Strategy(Json content, Context context) {
		this.updateContent(content);
		this.context = context;
	}
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
		this.md5.update(new Date().toString());
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

