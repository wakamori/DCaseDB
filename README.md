# DCase DB

##必要なライブラリ
* openssl
* sqlite(TODO)

##Class
* DBNode
    * Goal,Strategy,Evidence,Contextの親クラス

## API
### DCaseDB Class
* DCaseDB DCaseDB.new()
    * DCaseDBを扱うクラスの作成
    * 各操作はArgumentのTopGoalのnameを渡し、どのArgumentへの操作か決定する。

* DBNode CreateDBNode(String ArgumentName, Json content)
    * DBNodeを作成する。Json contentに引数を渡す。
    * Json 例:
<code>
    content = {
        "name" : "ReturnFunction",        //必須
        "DBNodeType" : "Goal",  //必須
        "description" : "", //任意
    }
</code>

    * DBNodeTypeに渡した名前のクラスを生成する。
    * nameは検索に使う。
    * Contextへの渡し方
<code>
    content = {
        "name" : "hogehoge",
        "DBNodeType" : "Context",
        "condition" : [{"architecture" : "Linux"},{"サーバ台数" : 4},  ...]
    }
</code>
* void   InsertLink(String ArgumentName, String parentName, String childName)
    * 各DBNodeを繋げる。DBNodeのparentNameとchildNameを渡す。

* void   UpdateDBNode(String ArgumentName, String DBNodeName , Json contents)
    * 変更したいDBNodeのnameとそのアップデート内容をJsonに渡す。
    * Jsonの内容はCreateDBNodeと同様。

* void   UpdateParentLink(String Treename, String OldParentName, String NewParentName, String ChildName)
    * 親Linkの差し替え。old->childを削除してnew->childを新しく作成するため、oldNameが必要。

* void   UpdateChildLink(String ArgumentName, String parent, String child_old, String child_new)
    * 子Linkの差し替え。UpdateParentLinkと同様

* void   DeleteDBNode(String ArgumentName, String nodeName)
    * DBNodeの削除。このDBNodeにつながっているLinkも自動削除されます。

* void   DeleteLink(String ArgumentName, String ParentName, String ChildName)
    * Linkの削除。

* DBNode SearchDBNode(String ArgumentName, String searchText)
    * DBNodeの検索。現状はnameが完全一致するDBNodeを返す。

* Argument SearchArgument(String ArgumentName)
    * Argumentの検索。現状はnameが完全一致するArgumentを返す。

* void   Connect()
    * すでにあるDBにアクセスする。現状未実装

* void   CreateArgument(String name)
    * Argumentの作成。nameにはTopGoalの名前をいれる。

### Argument Class
* Json   toJson()
    * Argumentの内部にある情報をすべてdumpする。<br />
    * 例:
<code>
    {
        "HEAD"      : "asfhdafjs",
        "root"      : {...},
        "links"     : [{...}, ...],
        "nodes"     : [{...}, ...],
        "CommitLog" : [{...}, ...]
    }
</code>
* HEAD      ... 最新リビジョンのSHA-1
* root      ... ArgumentのTop Goal
* links     ... DBNode間のLinkを示す(TODO: Tree構造に復元する)
* nodes     ... DBNodeの情報(Array[Json])
* CommitLog ... Commitの情報(Array[Json])

## Usage
test.k,test2.k参照
