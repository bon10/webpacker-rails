# How to Develop

```
$ docker-compose up
```

After the above command, start the rails server.

```
$ docker exec -it webpacker-rails_web_1 /bin/bash
# rails s -b 0.0.0.0
```

### 他

#### app/javascript を app/frontend にリネーム  

どこかのQiitaの記事でみたとおり、わかりやすくするためだが特に意味はない。

#### jQueryはyarnで管理(jquery-railsとかは使わない)  

`webpacker/environment.js`、 `app/frontend/packs/application.js` にjQuery使えるように追記。

#### sidekiq 起動  

bundle exec sidekiq

#### shrine設定  

UppyからS3にダイレクトアップロードをしていない（CORS設定が面倒だったため）  
その代わりUppyのDashboardに画像を追加するたびにプログレスバーが表示されRailsの/upload経由でS3にキャッシュがアップロードされる仕組みになっている。  
実ファイルはsidekiqでS3へアップロードされる

#### S3のディレクトリ  

`/cache/xxx`: キャッシュ画像。定期的に削除したほうがよい(アップロードされるたびに課金対象となるため注意)  
`/store/xxx`: 実際にpostから参照されるphotoのファイル。DBのphotoテーブルに書き込まれるJSONがS3上のどのファイルかを示す
