set e

# ローカルのデータベース起動を待つための待ち時間
echo "wait for database... $SLEEPING_TIME sec"
# 変数指定がなければ待たない
sleep $SLEEPING_TIME
bundle exec rake db:create db:migrate

bundle exec puma -C config/puma.rb
