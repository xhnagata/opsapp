# アプリサーバ<->データベース死活チェック検証用アプリ
ECS、EKSの動作検証を行うために利用するコンテナイメージです。

## 使い方
docker-composeを利用してローカルで動かす方法。
ローカルで動作確認する必要がない場合は読み飛ばして、ルートディレクトリのDockerfileを使ってイメージをビルドしてください。

```sh
$ docker-compose up
```
アプリ用のコンテナ起動時にデータベースの作成を実行しアプリサーバを起動します。

動作起動確認
GET: http://localhost:3000/health
`200 OK`が返却されたら、アプリが正しく起動しています。

GET: http://localhost:3000/health/readable
`200 OK`が返却されたら、アプリとSQL-Serverが正しく起動しています。

## アプリのコンテナイメージの作成
```sh
$ docker build .
```

### 必要な環境変数
コンテナに4つの環境変数を登録してください。
- RACK_ENV
    - アプリの環境名[development, staging, production]
        - development: ローカルの開発環境
        - staging: 検証環境
        - production: 本番環境
    - 本アプリでは特に意識しなくてかまいません。AWS環境で動かす場合は`staging`を指定してください。
- DATABASE_HOST
    - アプリが利用するSQL-Serverのホスト名
- DATABASE_USERNAME
    - アプリが利用するSQL-Serverのユーザネーム
- DATABASE_PASSWORD
    - アプリが利用するSQL-Serverのユーザパスワード

### データベースのユーザーに必要な権限
- データベース作成
- テーブル作成
- テーブル操作（CRUDすべて）

## ヘルスチェックAPI機能
### GET: /health
常に`200 OK`を返却します。
```
STATUS: 200
BODY: 200 OK
```

### GET: /health/readable
データベースに接続でき、テーブルへの読み取りが可能な場合は`200 OK`を返却します。
```
STATUS: 200
BODY: 200 OK
```

データベースへのアクセス、読み取りができない場合は、`500 Internal Server Error`を返却します。
```
STATUS: 500
BODY: 500 Internal Server Error
```

### GET: /health/writable
データベースに接続でき、テーブルへの書き込みが可能な場合は`200 OK`を返却します。
```
STATUS: 200
BODY: 200 OK
```

データベースへのアクセス、書き込みができない場合は、`500 Internal Server Error`を返却します。
```
STATUS: 500
BODY: 500 Internal Server Error
```

### GET: /health/toggle
`POST: /health/toggle`と合わせて使ってください。
`200 OK`か`503 Service Unavailable`のどちらかを返却します。
```
STATUS: 200
BODY: 200 OK
```
```
STATUS: 503
BODY: 503 Service Unavailable
```

### POST: /health/toggle
GETのレスポンス`200 OK`と`503 Service Unavailable`を入れ替えます。
入れ替えが成功した場合は`201 Created`を返却します。
```
STATUS: 201
BODY: 201 Created
```

データベースへのアクセスに失敗した場合は`500 Internal Server Error`を返却します。
```
STATUS: 500
BODY: 500 Internal Server Error
```
