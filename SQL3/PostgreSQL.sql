CREATE TABLE Usuarios (
  id INT,
  nombre VARCHAR(255),
  email VARCHAR(255),
  rol VARCHAR(255)
);

CREATE TABLE Cursos (
  id INT ,
  nombre VARCHAR(255),
  fecha_creacion DATE,
  autor_id INT
);

CREATE TABLE Comisiones (
  id INT,
  curso_id INT,
  fecha_inicio DATE ,
  profesor_id INT
);

CREATE TABLE Inscriptos (
  alumno_id INT,
  comision_id INT
);


INSERT INTO Usuarios (id,nombre, email, rol) VALUES
  (1,'Juan Perez', 'juan.perez@example.com', 'Alumno'),
  (2,'Maria Garcia', 'maria.garcia@example.com', 'Profesor'),
  (3,'Pedro Lopez', 'pedro.lopez@example.com', 'Profesor'),
  (4,'Fernando Hernandez', 'fernandoa@example.com', 'Profesor'),
  (5,'Ignacio', 'ignacio@example.com', 'Alumno'),
  (6,'Mateo', 'mateo@example.com', 'Alumno'),
  (7,'Morena', 'morena@example.com', 'Alumno'),
  (8,'lucia', 'lucia@example.com', 'Alumno'),
  (9,'Agostina', 'agostina@example.com', 'Alumno');

INSERT INTO Cursos (id, nombre, fecha_creacion, autor_id) VALUES
  (1,'Programación Web', '2024-05-23', 2),
  (2,'Bases de Datos', '2024-03-15', 2),
  (3,'Diseño Gráfico', '2024-01-01', 2),
  (4,'JavaScript', '2024-01-01', 4),
  (5,'React', '2024-02-11', 4);


INSERT INTO Comisiones (id, curso_id, fecha_inicio, profesor_id) VALUES
  (1, 1, '2024-06-01', 2),
  (2, 1, '2024-08-01', 3),
  (3, 1, '2024-05-02', 3),
  (4, 3, '2024-04-10', 2),
  (5, 3, '2024-04-12', 2),
  (6, 4, '2024-06-10', 4),
  (7, 4, '2024-06-12', 2);


INSERT INTO Inscriptos (alumno_id, comision_id) VALUES
  (5, 1),
  (6, 1),
  (7, 2),
  (8, 3),
  (5, 4),
  (8, 5),
  (6, 6),
  (7, 6),
  (5, 7);

SELECT * from usuarios;
SELECT * from cursos;
SELECT * from comisiones;
SELECT * from inscriptos;

--Cruza los datos de la tabla usuarios y cursos, mostrando las columnas nombre y email del usuario, nombre y fecha de creacion del curso

select u.nombre as autor, u.email, c.nombre as nombre_curso, c.fecha_creacion from usuarios u, cursos c
where u.id = c.autor_id;

select u.nombre as autor, u.rol, u.email, c.nombre as nombre_curso, c.fecha_creacion 
from usuarios u
JOIN cursos c
ON u.id = c.autor_id;

select u.nombre as autor, u.rol, u.email, c.nombre as nombre_curso, c.fecha_creacion 
from usuarios u
left JOIN cursos c
ON u.id = c.autor_id
where u.rol = 'Profesor';

--Cuenta las comisiones que tiene asignada cada profesor y agrupar por mail de profesor.
select usuarios.email ,count(*) as cantidad_de_comisiones 
from comisiones
JOIN usuarios
on comisiones.profesor_id = usuarios.id
GROUP by usuarios.email;

-- ❌
select usuarios.email ,count(comisiones.profesor_id) as cantidad_de_comisiones 
from comisiones
right JOIN usuarios
on comisiones.profesor_id = usuarios.id
GROUP by usuarios.email;

-- Cuenta las comisiones agrupadas por curso.
select CU.nombre ,count(CO.curso_id) as cantidad_de_comisiones
from comisiones CO
JOIN cursos CU
on CO.curso_id = CU.id
GROUP by CU.nombre



-- Muestra el email del usuario que esta inscripto en mas cursos.

select u.email, COUNT(i.alumno_id) as cantidad_inscripto
from usuarios u
JOIN inscriptos i 
on u.id = i.alumno_id
GROUP by u.email
ORDER by COUNT(i.alumno_id) DESC
LIMIT 1

-- Muestra la comision y nombre de curso con mas inscriptos.
select 
	cursos.nombre,
	comisiones.id, 
	count(inscriptos.comision_id) as cantidad_inscriptos
FROM cursos
JOIN comisiones
on cursos.id = comisiones.curso_id
join inscriptos
on comisiones.id = inscriptos.comision_id
GROUP by cursos.nombre,  comisiones.id
order by count(inscriptos.comision_id) DESC
limit 1

-- Cuenta los cursos en los que esta inscripto cada usuario.
select usuarios.nombre, 
	count(inscriptos.alumno_id) as cursos_en_que_esta_incripto
FROM inscriptos
join usuarios
on inscriptos.alumno_id = usuarios.id
GROUP by usuarios.nombre


select usuarios.nombre, 
	count(inscriptos.alumno_id) as cursos_en_que_esta_incripto
FROM inscriptos
RIGHT join usuarios
on inscriptos.alumno_id = usuarios.id
GROUP by usuarios.nombre

-- Muestra los usuarios que no se han inscripto en ninguna comision.

select usuarios.nombre, usuarios.rol,
	count(inscriptos.alumno_id) as cursos_en_que_esta_incripto
FROM inscriptos
RIGHT join usuarios
on inscriptos.alumno_id = usuarios.id
GROUP by usuarios.nombre,  usuarios.rol
HAVING count(inscriptos.alumno_id) = 0 and usuarios.rol = 'Alumno'











