#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER jirauser WITH PASSWORD 'qwerQWER' VALID UNTIL 'infinity';
    CREATE DATABASE jira WITH OWNER=jirauser ENCODING='UNICODE' LC_COLLATE='C' LC_CTYPE='C' TEMPLATE=template0;
    
    CREATE USER confluenceuser WITH PASSWORD 'qwerQWER' VALID UNTIL 'infinity';
    CREATE DATABASE confluence WITH OWNER=confluenceuser ENCODING='UTF8' LC_COLLATE='en_US.UTF-8' LC_CTYPE='en_US.UTF-8' TEMPLATE=template0;

    CREATE USER bitbucketuser WITH PASSWORD 'qwerQWER' VALID UNTIL 'infinity';
    CREATE DATABASE bitbucket WITH ENCODING='UTF8' OWNER=bitbucketuser CONNECTION LIMIT=-1 TEMPLATE=template0;

    CREATE USER bamboouser WITH PASSWORD 'qwerQWER' VALID UNTIL 'infinity';
    CREATE DATABASE bamboo WITH OWNER=bamboouser TEMPLATE=template0;
EOSQL