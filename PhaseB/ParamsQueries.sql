--in case of a succecful mission, promote all the Majors from the chosen squadron from Major to Sgt Major
UPDATE Soldier s
SET s.rank = 'Sgt Major'
WHERE s.rank = 'Major'
  AND s.id IN (
      SELECT p.id
      FROM Pilot p
      JOIN Squadron sq ON p.squadron_number = sq.squadron_number
      WHERE sq.suadron_name = '&name'
  );

--to check exeptional pilots who have flown in many different months(different wether conditions)
SELECT 
    p.id,
    p.call_sign,
    (SELECT SUM(f.duration)
     FROM Flight f
     WHERE f.id = p.id) AS total_flight_hours,
    (SELECT COUNT(DISTINCT f.name)
     FROM Flight f
     WHERE f.id = p.id) AS number_of_airbases
FROM 
    Pilot p
WHERE 
    (SELECT COUNT(DISTINCT TO_CHAR(f.flight_date, 'MM'))
     FROM Flight f
     WHERE f.id = p.id) > &num_of_months;

--to know where to celebrate the aniversery of the squadrons all the airbases who host a squadron whose formation year is 1990(ignore month and day)
SELECT 
    ab.name,
    ab.location,
    ab.squadron_number
FROM 
    Airbase ab
JOIN 
    Squadron sq ON ab.squadron_number = sq.squadron_number
WHERE 
    EXTRACT(YEAR FROM sq.formation_date) = &year;

--because of recent complaints of sickness, check all pilots who flew in a plane with a gforce limit above chosen
SELECT 
    s.first_name,
    s.last_name,
    p.id
FROM 
    Pilot p
JOIN 
    Flight f ON p.id = f.id
JOIN 
    Airplane a ON f.serialid = a.serialid
JOIN 
    Aircraft ac ON a.serialid = ac.serialid
JOIN 
    Soldier s ON p.id = s.id
WHERE 
    a.gforce_limit > &<name=regolation_limit type="integer" hint="limit between 1 and 9" ifempty="0">;
