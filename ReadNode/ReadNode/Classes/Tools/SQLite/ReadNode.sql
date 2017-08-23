CREATE TABLE "T_ReadNode" (
    "id" INTEGER NOT NULL DEFAULT 0,
    "title" TEXT NOT NULL,
    "rssFeed" TEXT,
    PRIMARY KEY("id","title")
)
