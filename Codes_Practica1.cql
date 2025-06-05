// 4.3 
call db.schema.nodeTypeProperties

// 4.4
call db.schema.relTypeProperties

// 4.5 
MATCH (p:Person)
RETURN COUNT(DISTINCT p);

MATCH (d:Droid)
RETURN COUNT(DISTINCT d);

MATCH (m:Movie)
RETURN COUNT(DISTINCT m);

// 4.7 
MATCH ()-[r:SPEAKS_WITH]->()
RETURN COUNT(DISTINCT r);

MATCH ()-[r2:APPEARS_IN]->(m:Movie)
RETURN COUNT(DISTINCT r2);

// 4.11 
MATCH (p:Person)-[r:SPEAKS_WITH]->(:Person)
RETURN p.name AS Persona, COUNT(r) as Personas
ORDER BY Personas DESC; 

// 4.14
MATCH (p:Person)
WITH p
MATCH (p)-[r]->()
RETURN p.name AS Persona, COUNT(DISTINCT r) AS OutDegree
ORDER BY OutDegree DESC;

// 4.17
MATCH (d:Droid)-[r:SPEAKS_WITH]->(p:Person)
RETURN COUNT(r);

// 4.18
MATCH (p)
WITH p
MATCH (p)<-[r]-(m)
RETURN p.name AS Nodo, COUNT(DISTINCT r) AS InDegree
ORDER BY InDegree DESC
LIMIT 10; 