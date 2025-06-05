// Limpia la pantalla
:clear

// Historial de comandos que se han corrido
:history

// Nodos
()
:Persona
:persona // TODAS son etiquetas distintas, en Cypher si importan las mayúsculas y minúsculas
:PERSONA
:personA

(:Persona) // Representación de un nodo con la etiqueta "Persona"

// Atributos
{}
nombre
NOMBRE // De nuevo, atributos distintos
Nombre

{nombre:'Juan'} // Representación de un atributo con un valor

// Relaciones
-- <-- -->


-[]- <-[]- -[]->
:AMIGO
:amigo
:Amigo

CREATE // Sirve para crear relaciones, nodos, etc

CREATE (:Persona);
CREATE (:Persona {nombre:"Juan"});
CREATE (:Persona {nombre:"Juan"})-[:AMIGO]->(:Persona{nombre:"Luis"})

MERGE (:Persona {nombre:"Juan"});

// Terminología SQL vs Cypher
// SELECT = RETURN
// FROM = MATCH
// WHERE = WHERE

RETURN 100*3

MATCH (n)
RETURN n AS Nodos;

MATCH (n:Persona)

MATCH (n)-[r:AMIGO]->(m)
RETURN n, r,m;

MERGE (:Producto {desc:"Lapiz"})-[:PARTE_DE]->(:Categoria {nombre:"Papeleria"})
MERGE (:Tienda {nombre:"Superpapelerias"})-[:TIENE]->(:Producto {desc:"Lapiz"})
MERGE (:Tienda {nombre:"Superpapelerias"})-[:TIENE]->(:Producto {desc:"Monitor"})

CREATE (:Producto {desc:"Monitor"})<-[:TIENE]-(:Tienda {nombre:"Superpapelerias"})-[:TIENE]->(:Producto {desc:"Lapiz"})-[:PARTE_DE]->(:Categoria {nombre:"Papeleria"})

// Para agregarle otro más
MATCH (t:Tienda {nombre:"Superpapelerias"})
CREATE (t)-[:TIENE]->(:Producto {desc:"Teclado"})


// BORRAR TODO
MATCH (n) DETACH DELETE (n);

MATCH (t:Tienda {nombre:"Superpapelerias"})
CREATE (t)<-[r:OWNER]-(p:Persona{nombre:"Luis"}) 


MATCH (t:Tienda {nombre:"Superpapelerias"})
RETURN t;

MATCH (t:Tienda {nombre:"Superpapelerias"})
MERGE (t)<-[r:OWNER]-(p:Persona{nombre:"Luis"}); 

MATCH (t:Tienda {nombre:"Superpapelerias"})
MATCH (p:Persona{nombre:"Luis"})
MERGE (t)<-[r:OWNER]-(p); 

// Muestra el schema
call db.schema.visualization

// Mostrar atributos de nodos
call db.schema.nodeTypeProperties

// Mostrar atributos de relaciones
call db.schema.relTypeProperties

// Contar todos los nodos tipo Person
MATCH (p:Person)
RETURN COUNT(DISTINCT p);

// Contar todos los nodos de un tipo
MATCH (p:Person)-[r:FOLLOWS]->(p:Person)
RETURN COUNT(DISTINCT r);

// AZul - Zoé (Muestra películas donde actúa Tom Hanks)
MATCH (p:Person {name:"Tom Hanks"})-[r:ACTED_IN]->(m:Movie)
RETURN p,r,m

// Ver si coinciden dos personas en una peli, en cualquier rol
MATCH (p:Person {name:"Tom Hanks"})-[r]->(m:Movie)<-[r2]-(p2:Person {name:"Keanu Reeves"})
RETURN p,m,p2;

// DEGREE TOTAL KEVIN BACON
MATCH (p:Person {name:"Kevin Bacon"})-[r]->()
MATCH (p:Person {name:"Kevin Bacon"})<-[2]-()
MATCH (p:Person {name:"Kevin Bacon"})-[r3]-()
RETURN p.name AS Persona,
        COUNT(DISTINCT r) as OutDegree,
        COUNT(DISTINCT r2) as InDegree,
        COUNT(DISTINCT r3) as Degree;

// Consulta para in, out, y Degree de un nodo
// Out
MATCH (p:Person {name:"Kevin Bacon"})
WITH p
MATCH (p)-[r]->(m)
RETURN p.name, COUNT(DISTINCT r) AS OutDegree; 

// IN
MATCH (p:Person {name:"Kevin Bacon"})
WITH p
MATCH (p)<-[r]-(m)
RETURN p.name, COUNT(DISTINCT r) AS InDegree; 

// Degree
MATCH (p:Person {name:"Kevin Bacon"})
WITH p
MATCH (p)-[r]-(m)
RETURN p.name AS Actorx, COUNT(DISTINCT r) AS Degree;

// Degree
MATCH (p:Person {name:"Kevin Bacon"})
WITH p
MATCH (p)-[r1]->(m) 
MATCH (p)<-[r2]-(m) 
MATCH (p)-[r3]-(m)
RETURN p.name AS Actorx, COUNT(DISTINCT r1) AS OutDegree, COUNT(DISTINCT r2) AS InDegree, COUNT(DISTINCT r3) AS Degree;

// Subconsulta

MATCH (p:Person)
CALL {
        WITH p
        MATCH (p)-[r]->(m)
        RETURN COUNT(DISTINCT r) AS OutDegree
}
CALL {
       WITH p
        MATCH (p)<-[r]-(m)
        RETURN COUNT(DISTINCT r) AS InDegree  
}
CALl {
        WITH p
        MATCH (p)-[r]-(m)
        RETURN COUNT(DISTINCT r) AS Degree
}
RETURN p.name, OutDegree,InDegree,Degree
ORDER BY Degree DESC LIMIT 5;

// Peliculas con mayor Degree
MATCH (p:Movie)
CALL {
        WITH p
        MATCH (p)-[r]->(m)
        RETURN COUNT(DISTINCT r) AS OutDegree
}
CALL {
       WITH p
        MATCH (p)<-[r]-(m)
        RETURN COUNT(DISTINCT r) AS InDegree  
}
CALl {
        WITH p
        MATCH (p)-[r]-(m)
        RETURN COUNT(DISTINCT r) AS Degree
}
RETURN p.title, OutDegree,InDegree,Degree
ORDER BY Degree DESC;

// Crear parametros
:help param

:param name => 'Kevin Bacon';
:param num => 2; 
RETURN $name, $num;

// Muestra las transacciones y los parametros creados
SHOW TRANSACTIONS YIELD *;

// Todos los nodos que Kevin Bacon puede alcanzar en 2 pasos
MATCH (p:Person{name:'Kevin Bacon'})-[*1..2]-(m)
RETURN COUNT(DISTINCT m);

// Todos los nodos que Kevin Bacon puede alcanzar en 2 pasos EXACTOS
MATCH (p:Person{name:'Kevin Bacon'})-[*2]-(m)
RETURN COUNT(DISTINCT m);

// BLOOM

/// DATASET Star Wars


// Cuantos nodos persona y cuantos nodos movie hay?
MATCH (p:Person)
RETURN p.name AS Nombre, p.born AS Fecha De Nacimiento
ORDER BY p.born;

// # de actores por película
MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
RETURN m.title AS Peli, COUNT(p) as Personas DESC; 

// Top 5 películas con más actores
MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
RETURN m.title AS Peli, COUNT(p) as Personas
ORDER BY Personas DESC
LIMIT 5;