CREATE TABLE node
(
    node_id   INTEGER PRIMARY KEY,
    node_name VARCHAR NOT NULL
);

CREATE TABLE edge
(
    node1 INTEGER REFERENCES node (node_id),
    node2 INTEGER REFERENCES node (node_id),
    PRIMARY KEY (node1, node2)
);

INSERT INTO node (node_id, node_name)
VALUES (1, 'Tom'),
       (2, 'Dick'),
       (3, 'Harry'),
       (4, 'Jane'),
       (5, 'Susan'),
       (6, 'Mary'),
       (7, 'Sam'),
       (8, 'Sally'),
       (9, 'Jack');

INSERT INTO edge (node1, node2)
VALUES (1, 2),
       (1, 8),
       (2, 3),
       (2, 4),
       (4, 5),
       (4, 6),
       (4, 7),
       (8, 9);

-- Using a regular (non-recursive) CTE, define a view nodes_n_edges which contains the names and IDs of
-- adjacent node pairs:
DROP VIEW IF EXISTS nodes_n_edges;
CREATE OR REPLACE VIEW nodes_n_edges AS
WITH cte1 AS
         (SELECT n.node_id   AS node1_id,
                 n.node_name AS node1_name,
                 e.node2     AS node2_id
          FROM node AS n
                   JOIN edge AS e
                        ON n.node_id = e.node1)
SELECT c.node1_id,
       c.node1_name,
       n.node_name AS node2_name,
       n.node_id   AS node2_id
FROM cte1 AS c
         JOIN node AS n ON
    n.node_id = c.node2_id;

SELECT *
FROM nodes_n_edges;

-- Get the names of all the people who belong to the branch with the root node as Dick

WITH RECURSIVE branch_root AS
                   (
                       -- anchor member
                       SELECT node2_name

                       FROM nodes_n_edges
                       WHERE node1_name = 'Dick'

                       UNION

                       -- recursive term
                       SELECT nne.node2_name
                       FROM nodes_n_edges AS nne
                                JOIN branch_root as br
                                     ON nne.node1_name = br.node2_name)
SELECT *
FROM branch_root
;

-- with traversal depth

WITH RECURSIVE branch_root AS
                   (
                       -- anchor member
                       SELECT node2_name,
                              1                                     as depth,
                              CONCAT(node1_name, ' : ', node2_name) AS root

                       FROM nodes_n_edges
                       WHERE node1_name = 'Tom'

                       UNION

                       -- recursive term
                       SELECT nne.node2_name,
                              br.depth + 1 AS depth,
                              CONCAT(br.root,' - ', nne.node2_name)
                       FROM nodes_n_edges AS nne
                                JOIN branch_root as br
                                     ON nne.node1_name = br.node2_name
                       WHERE depth < 3)
SELECT *
FROM branch_root
;

