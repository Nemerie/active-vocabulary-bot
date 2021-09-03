# require 'rubygems'
# require 'bundler/setup'
require 'pg'
require_relative '.config'


namespace :db do

  desc 'Migrate the database'
  task :migrate do
    conn = PG.connect Config.db_credentials
    conn.exec(
      "CREATE SEQUENCE cards_ids;
       CREATE TABLE cards (
         id INTEGER PRIMARY KEY DEFAULT NEXTVAL('cards_ids'),
         definition TEXT,
         user_id INTEGER,
         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
       );
       CREATE UNIQUE INDEX user_id_idx ON cards (user_id);" 
    )
  end

  desc 'Drop the database'
  task :drop do
    conn = PG.connect Config.db_credentials
    conn.exec(
      "DROP TABLE cards;
       DROP SEQUENCE cards_ids;"
    )
  end
end
