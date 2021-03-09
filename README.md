# README


## アプリケーション名
 「SHIFT POST」


## アプリケーション概要
  アルバイトなどのシフトのための出勤希望時間を提出できるアプリケーションです。  
  Ruby on Railsで作成しました。


## 作成理由
  私のアルバイト先では、シフト希望の提出が紙で行われていました。それも、締め切りまでに休憩室にある記入表に書き込むというものでした。これでは、締め切り前付近にちょうど良く出勤日がないときに困りますし、スケジュールを変更したいときに書き変えるのも一苦労です。これを解決するため、シフト希望の募集と、それに対する希望登録ができるアプリを作成してみました。

## 使用例

## URL


## テスト用アカウント


## 利用方法
シフト希望の募集を開始する前にいくつかの手順が必要です。
###### 1. オーナーの方（シフト希望を集める側）
「管理者の方はこちら」からアカウントを作成してください。次に、設定したユーザーIDを従業員の方々に公開してください。  
###### 2. 従業員の方
「従業員の方はこちら」からアカウントを作成してください。次に、ヘッダーメニューの「管理者を検索」の検索フォームに、オーナーのIDを入力して検索し、「登録リクエストを送る」をクリックしてください。
###### 3. オーナーの方
従業員の方からの登録リクエストが、「追加リクエスト」に届きます。「承認する」を選ぶと、そのユーザーが「従業員一覧」に追加され、あなたの公開するシフト希望の募集に対して登録できるようになります。その後、ヘッダーメニューから「募集中一覧」を選び、「新規作成」からすぐにシフト希望の募集を開始できます。


## データベース
以下にデータベースの各テーブルとそのカラムについて簡単に示します。id、created_at、 updated_atカラムについては省略します。

###### ownersテーブル
管理者ユーザーのテーブルです。  

name (string) | userid (integer) | email (string) | password_digest (string)
-|-|-|-
名前 | ユーザーID | メールアドレス | ハッシュ化されたパスワード

###### workersテーブル
従業員ユーザーのテーブルです。構造はownersと同じです。

name (string) | userid (integer) | email (string) | password_digest (string)
-|-|-|-
名前 | ユーザーID | メールアドレス | ハッシュ化されたパスワード

###### tasksテーブル
管理者ユーザーが発行するシフト募集のテーブルです。

title (string) | owner_id (integer) | deadline (date) | from_date (date) | to_date (date) | comment (text)
-|-|-|-|-|-
タイトル | 発行した管理者ユーザーのID | 締め切り | 何日から | 何日まで | コメント

###### entriesテーブル
taskに対して、従業員ユーザーが登録する出勤可能時間のテーブルです。

worker_id (integer) | task_id (integer) | day (date) | attendance (boolean) | from_time_h (integer) | from_time_m (integer) | to_time_h (integer) | to_time_m (integer) |
-|-|-|-|-|-|-|-
登録した従業員のID | このentryが属しているtaskのID | どの日の | そもそも出勤可能か否か | 何時の | 何分から | 何時の | 何分まで |

###### owner_workersテーブル
一人の管理者ユーザーに対して従業員ユーザーが複数いるのは当然ですが、従業員がアルバイトを掛け持ちする可能性も考えて、ownerとworkerは多対多の関係になっています。そのための中間テーブルです。

owner_id (integer) | worker_id (integer)
-|-
管理者ユーザーのID | 従業員ユーザーのID

###### requestテーブル
登録リクエストのテーブルです。リクエストが承認されるとそのレコードは削除され、同じ内容のレコードがowner_workersテーブルに追加されます。

owner_id (integer) | worker_id (integer)
-|-
管理者ユーザーのID | 従業員ユーザーのID


## 頑張った所