// 4.1 
call db.schema.visualization

// 4.3 
call db.schema.nodeTypeProperties

// 4.4
call db.schema.relTypeProperties

// 4.5 
MATCH (p:Person)
MATCH (m:Movie)
MATCH (d:Droid)
RETURN COUNT(DISTINCT p) AS Personas, COUNT(DISTINCT m) AS Movies, COUNT(DISTINCT d) AS Droides;

// 4.6
MATCH (n) RETURN COUNT(n);

// 4.7 
MATCH ()-[r:APPEARS_IN]->()
MATCH ()-[r2:SPEAKS_WITH]->()
RETURN COUNT(DISTINCT r) AS Aparece, COUNT(DISTINCT r2) AS HablaCon;

// 4.8
MATCH ()-[r]->() RETURN COUNT(r);

// 4.11 
MATCH (p:Person)-[r:SPEAKS_WITH]->(p2:Person)
WITH p.name AS Persona,COUNT(r) AS TotalPersonas, COLLECT(p2.name) AS GenteConQuienHabla
RETURN Persona,TotalPersonas,GenteConQuienHabla
ORDER BY TotalPersonas DESC; 

// 4.12 
MATCH (p:Person {name:"ANAKIN"})
WITH p
MATCH (p)-[r:SPEAKS_WITH]->(d:Droid)
RETURN p.name AS Person, COUNT(r) AS DroidsSpokenTo, COLLECT(d.name) AS Droids; 

// 4.13
MATCH (p:Person {name:$Persona})
WITH p 
MATCH (p)-[r1:SPEAKS_WITH]->(p2:Person)
MATCH (p)-[r2:SPEAKS_WITH]->(d:Droid)
MATCH (p)-[r3:APPEARS_IN]->(m:Movie)
RETURN p,p2,d,m,r1,r2,r3;

// 4.14
MATCH (p:Person)
WITH p
MATCH (p)-[r]->()
RETURN p.name AS Persona, COUNT(DISTINCT r) AS OutDegree
ORDER BY OutDegree DESC;

// 4.15
MATCH (m:Movie{name:$Peli})-[*1..2]-(n)
RETURN COUNT(DISTINCT n);

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