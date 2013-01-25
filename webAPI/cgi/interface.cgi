#! /usr/local/bin/minikonoha -MFuelVM

Load("webapi.k");

void main() {
	Json j = Json.parse(getMsg());
	WebAPI api = new WebAPI();
	if (!checkVersion(j.getInt("version"))) {
		throw_VersionMissMatch(j);
		return;
	}
	if (!checkID(j)) {
		// add id
	}
	Func[boolean, Json] checkParam = api.paramCheck[j.getString("method")];
	Func[String, Json] run = api.run[j.getString("method")];
	if (!checkParam(j.get("param"))) {
		// error handling
	}
	String result = run(j.get("param"));
	flush(result);
}

main();
