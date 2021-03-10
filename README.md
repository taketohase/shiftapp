# README


## アプリケーション名
 「SHIFT POST」  
 ![logo](https://github.com/taketohase/README_images/blob/main/logo.png)


## アプリケーション概要
  アルバイトなどのシフトのための出勤希望時間を提出できるアプリケーションです。  
  Ruby on Railsで作成しました。


## 作成理由
  私のアルバイト先では、シフト希望の提出が紙で行われていました。それも、締め切りまでに休憩室にある記入表に書き込むというものでした。これでは、締め切り前付近にちょうど良く出勤日がないときに困りますし、スケジュールを変更したいときに書き変えるのも一苦労です。これを解決できるような、シフト希望の募集とそれに対する希望登録ができるアプリを作成してみました。

## 使用例
  画像のように、シフトを募集すると、従業員の希望を表形式で集めることができます。  
  ![example](https://github.com/taketohase/README_images/blob/main/example1.JPG)

## URL
  herokuでデプロイしました。
  URLはこちら  
  [SHIFT POST](https://shift-post.herokuapp.com/)

## テスト用アカウント
#### 管理者
  「スーパー青山」というスーパーマーケットの店長という設定です。  
  ユーザーID: super_aoyama  
  パスワード: superaoyama

#### 従業員
  「スーパー青山」で働く「渋谷 春人」君です。（架空の人物です。）  
  ユーザーID: aoyama0001  
  パスワード: shibuharu

## 利用方法
シフト希望の募集を開始する前にいくつかの手順が必要です。
#### 1. オーナーの方（シフト希望を集める側）
「管理者の方はこちら」からアカウントを作成してください。次に、設定したユーザーIDを従業員の方々に公開してください。  
#### 2. 従業員の方
「従業員の方はこちら」からアカウントを作成してください。次に、ヘッダーメニューの「管理者を検索」の検索フォームに、オーナーのIDを入力して検索し、「登録リクエストを送る」をクリックしてください。
#### 3. オーナーの方
従業員の方からの登録リクエストが、「追加リクエスト」に届きます。「承認する」を選ぶと、そのユーザーが「従業員一覧」に追加され、あなたの公開するシフト希望の募集に対して登録できるようになります。その後、ヘッダーメニューから「募集中一覧」を選び、「新規作成」からすぐにシフト希望の募集を開始できます。


## データベース
以下にデータベースの各テーブルとそのカラムについて簡単に示します。id、created_at、 updated_atカラムについては省略します。

#### ownersテーブル
管理者ユーザーのテーブルです。  

name (string) | userid (integer) | email (string) | password_digest (string)
-|-|-|-
名前 | ユーザーID | メールアドレス | ハッシュ化されたパスワード

#### workersテーブル
従業員ユーザーのテーブルです。構造はownersと同じです。

name (string) | userid (integer) | email (string) | password_digest (string)
-|-|-|-
名前 | ユーザーID | メールアドレス | ハッシュ化されたパスワード

#### tasksテーブル
管理者ユーザーが発行するシフト募集のテーブルです。

title (string) | owner_id (integer) | deadline (date) | from_date (date) | to_date (date) | comment (text)
-|-|-|-|-|-
タイトル | 発行した管理者ユーザーのID | 締め切り | 何日から | 何日まで | コメント

#### entriesテーブル
taskに対して、従業員ユーザーが登録する出勤可能時間のテーブルです。

worker_id (integer) | task_id (integer) | day (date) | attendance (boolean) | from_time_h (integer) | from_time_m (integer) | to_time_h (integer) | to_time_m (integer) |
-|-|-|-|-|-|-|-
登録した従業員のID | このentryが属しているtaskのID | どの日の | そもそも出勤可能か否か | 何時の | 何分から | 何時の | 何分まで |

#### owner_workersテーブル
一人の管理者ユーザーに対して従業員ユーザーが複数いるのは当然ですが、従業員がアルバイトを掛け持ちする可能性も考えて、ownerとworkerは多対多の関係になっています。そのための中間テーブルです。

owner_id (integer) | worker_id (integer)
-|-
管理者ユーザーのID | 従業員ユーザーのID

#### requestsテーブル
登録リクエストのテーブルです。リクエストが承認されるとそのレコードは削除され、同じ内容のレコードがowner_workersテーブルに追加されます。

owner_id (integer) | worker_id (integer)
-|-
管理者ユーザーのID | 従業員ユーザーのID


## 頑張った所、工夫したところ
#### 複数レコード一括保存用のコレクションモデル
  従業員がシフト希望を登録する際、その対象となる期間の日数に応じて入力フォーム数を変えて、それらを同時に保存する必要がありました。下の画像は、4/1～4/3のシフトに対する登録フォームです。登録ボタン一つで、3つのレコードを同時に保存する必要がある例です。  
  ![new_entry_form](https://github.com/taketohase/README_images/blob/main/new_entry_form.JPG)  
  このために、専用のコレクションモデルの作成、使用をしてみました。以下コードへのリンクです。  
  [entry_collection.rb](https://github.com/taketohase/shiftapp/blob/master/app/models/form/entry_collection.rb)  
  [entries_controller.rb](https://github.com/taketohase/shiftapp/blob/master/app/controllers/entries_controller.rb)  
  [new.html.erb](https://github.com/taketohase/shiftapp/blob/master/app/views/entries/new.html.erb)  
  作成にあたって、同じようなことを試みている方の記事を何とか見つけ、参考にさせていただきました。  
  [複数レコードの一括保存について](https://qiita.com/kinop1987/items/63586892116446043365)

#### シフト希望表のためのハッシュ
  シフト希望は、下の写真に示すような表で表示されます。（tasks/show）  
  ![entries_table](https://github.com/taketohase/README_images/blob/main/entries_table.JPG)  
  そこで、ビューやコントローラが厚くならないように、モデルにget_entries_tableメソッドを定義しました。  
  [task.rb](https://github.com/taketohase/shiftapp/blob/master/app/models/task.rb)  
  ここでは、taskが持っているentryをハッシュにまとめています。キーに従業員のid、バリューに日数分のentryの配列を持っています。例えば上の画像のtaskに対しては、  
  { 渋谷春人のid => [[ "4/1のentryのid", "17:00-22:30" ],  
  　　　　　　　　　　[ "4/2のentryのid", "17:00-22:30" ],...],  
  　宇都宮健太のid => [[ "4/1のentryのid", "×" ],  
  　　　　　　　　　　　[ "4/2のentryのid", "×" ],...],  
  　...}  
  となっています。時間の表示が文字列で、フリーなら"フリー"、時間指定があれば"hh:mm-hh:mm"、出勤不可なら"×"がこの時点で入っています。このハッシュをviewに渡せば、view内ではこれを順番に取り出すだけで済みます。

#### Excel出力
  従業員の希望表を編集しやすい形で手元に残せた方が便利かもしれないと思い、Excelファイルとしてダウンロードできる機能を付けました。シフト希望表の上にある「Excelファイルとしてダウンロード」ボタンからダウンロードできます。エクセルファイルのレイアウトは[show.xlsx.axlsx](https://github.com/taketohase/shiftapp/blob/master/app/views/tasks/show.xlsx.axlsx)で行っています。

#### Gitの使い方, herokuでのデプロイ
  このアプリを作成、公開してみようとするまでGitを使ったことがなかったので、使い方を理解するのは大変でした。また、herokuでのデプロイも、ローカルで動かすのと環境が違うため、設定に何度か躓きました。まだ使いこなせているとは言えませんが、この機会にこれらの使用に触れられたことは良かったと思います。
