#!/usr/local/bin/minikonoha

import("cstyle.file");
load("dcasedb_glue.k");


void main() {
	String TreeName = "BasicSyntax";

	DCaseDB repo = new DCaseDB();
	repo.Connect("dcasedb","dcasedb");

	stdout.println("Content-type: application/json\n\n");
	stdout.println(repo.SearchArgument(TreeName).toJson());
}

main();
