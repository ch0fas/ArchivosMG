WITH "https://raw.githubusercontent.com/ch0fas/ArchivosMG/refs/heads/main/Data/social-nodes.csv" AS uri
LOAD CSV WITH HEADERS FROM uri AS row
MERGE (:User {id: row.id})

