
----建表-----
CREATE TABLE IF NOT EXISTS "status" (
    "userid" integer,
    "statusid" integer,
    "text" text,
    "createTime" text DEFAULT (datetime('now','localtime')),
    PRIMARY KEY ("userid", "statusid")
);
