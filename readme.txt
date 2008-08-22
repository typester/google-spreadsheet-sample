使い方

1. list.pl add.plともにアカウント情報を書き換える


2. 自分のspreadsheetのリストをえる

   $ perl list.pl


3. 編集したいspreadsheetのworksheet一覧をえる

   $ perl list.pl "2ででたedit_link"


4. 指定したworksheetにデータ追加

   $ perl add.pl "3で出たedit_link"

   あらかじめカラムは作成しておく必要がある。
   追加するデータはスクリプト内にハードコードしてあるからみて
